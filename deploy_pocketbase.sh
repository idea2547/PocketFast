#!/bin/bash

# Input arguments: USERNAME and PORT
USER=$1
PORT=$2

# Check if required environment variables are set
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "ERROR: CLOUDFLARE_API_TOKEN environment variable is not set"
    echo "Please set it with: export CLOUDFLARE_API_TOKEN='your_token_here'"
    exit 1
fi

if [ -z "$CLOUDFLARE_ZONE_ID" ]; then
    echo "ERROR: CLOUDFLARE_ZONE_ID environment variable is not set"
    echo "Please set it with: export CLOUDFLARE_ZONE_ID='your_zone_id_here'"
    exit 1
fi

if [ -z "$CLOUDFLARE_TUNNEL_TARGET" ]; then
    echo "ERROR: CLOUDFLARE_TUNNEL_TARGET environment variable is not set"
    echo "Please set it with: export CLOUDFLARE_TUNNEL_TARGET='your_tunnel_target_here'"
    exit 1
fi

if [ -z "$DOMAIN" ]; then
    echo "ERROR: DOMAIN environment variable is not set"
    echo "Please set it with: export DOMAIN='your_domain_here'"
    exit 1
fi

# Generate a random password for the admin user
PASSWORD=$(openssl rand -base64 12)

# Use environment variables for sensitive information
API_TOKEN="$CLOUDFLARE_API_TOKEN"
ZONE_ID="$CLOUDFLARE_ZONE_ID"
TUNNEL_TARGET="$CLOUDFLARE_TUNNEL_TARGET"
SUBDOMAIN="$USER.$DOMAIN"

# Step 1: Create user data folder
mkdir -p ./data/$USER

# Step 2: Run the PocketBase Docker container
docker run -d --name pocketbase_$USER -p $PORT:8080 -v ./data/$USER:/app/data pocketfast

# Step 3: Initialize the PocketBase admin user
curl -X POST "http://localhost:$PORT/api/admins" \
     -H "Content-Type: application/json" \
     -d '{
           "email": "'$USER@example.com'",
           "password": "'$PASSWORD'",
           "passwordConfirm": "'$PASSWORD'"
         }'

# Step 4: Call Cloudflare API to create DNS record for the user's subdomain
curl -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
     -H "Authorization: Bearer ${API_TOKEN}" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "CNAME",
       "name": "'"${SUBDOMAIN}"'",
       "content": "'"${TUNNEL_TARGET}"'",
       "ttl": 3600,
       "proxied": true
     }'

# Step 5: Add new hostname to NGINX configuration
NGINX_CONF="/etc/nginx/sites-available/saas.conf"

sudo sed -i "/server {/a \\
    server {\\
        listen 9000;\\
        server_name ${SUBDOMAIN};\\
        \\n\
        location / {\\
            proxy_pass http://localhost:${PORT};\\
            proxy_set_header Host \$host;\\
            proxy_set_header X-Real-IP \$remote_addr;\\
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\\
            proxy_set_header X-Forwarded-Proto \$scheme;\\
        }\\
    }" $NGINX_CONF

# Step 6: Reload NGINX to apply changes
sudo nginx -t && sudo systemctl reload nginx

# Add a new hostname to the config.yml
sudo sed -i "/ingress:/a \  - hostname: \"${SUBDOMAIN}\"\n    service: http://localhost:${PORT}" /etc/cloudflared/config.yml

sudo systemctl restart cloudflared

# Step 7: Output the success message
echo "PocketBase instance created for user $USER"
echo "Access PocketBase via: http://${SUBDOMAIN}"
echo "Admin credentials: $USER@example.com / $PASSWORD"

