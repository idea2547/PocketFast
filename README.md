# PocketFast 🚀

**Multi-tenant PocketBase SaaS deployment automation tool**

PocketFast is a powerful automation tool that enables you to rapidly deploy isolated PocketBase instances for multiple users or clients. It's designed for SaaS providers, development agencies, or anyone who needs to quickly spin up separate PocketBase databases with custom subdomains.

## 🎯 What Does PocketFast Do?

PocketFast automates the entire process of creating isolated PocketBase instances for multiple users:

### **Core Functionality:**
- **🚀 Instant Deployment**: Deploy a new PocketBase instance in seconds
- **🏠 Multi-tenancy**: Each user gets their own isolated database and instance
- **🌐 Custom Subdomains**: Automatic subdomain creation (e.g., `user1.yourdomain.com`)
- **🔐 Admin Setup**: Pre-configured admin accounts with secure random passwords
- **📱 Cloudflare Integration**: Automatic DNS record creation and tunnel configuration
- **⚡ Reverse Proxy**: NGINX configuration for proper routing and SSL termination

### **Perfect For:**
- **SaaS Platforms** - Offer PocketBase as a service to multiple clients
- **Development Agencies** - Quickly provision databases for different projects
- **Multi-tenant Applications** - Isolate data between different user groups
- **Testing & Development** - Spin up isolated environments for different features
- **Client Projects** - Give each client their own PocketBase instance

## 🏗️ Architecture

```
User Request → deploy_pocketbase.sh → Docker Container → PocketBase Instance
                    ↓
            Cloudflare DNS + Tunnel → Custom Subdomain → NGINX Proxy
```

### **Components:**
1. **Docker Container**: Isolated PocketBase instance per user
2. **Data Isolation**: Separate data directories for each user
3. **Network Isolation**: Unique ports for each instance
4. **Domain Management**: Automatic subdomain creation via Cloudflare API
5. **Reverse Proxy**: NGINX handles routing and SSL termination

## 🚀 Quick Start

### **Prerequisites:**
- Docker installed and running
- Cloudflare account with API access
- NGINX configured on your server
- Cloudflare Tunnel (cloudflared) set up

### **1. Set Environment Variables:**
```bash
export CLOUDFLARE_API_TOKEN="your_api_token"
export CLOUDFLARE_ZONE_ID="your_zone_id"
export CLOUDFLARE_TUNNEL_TARGET="your_tunnel_target"
export DOMAIN="yourdomain.com"
```

### **2. Deploy a New Instance:**
```bash
./deploy_pocketbase.sh username port_number
```

**Example:**
```bash
./deploy_pocketbase.sh client1 8090
```

### **3. What Happens Automatically:**
- ✅ Creates isolated data directory for the user
- ✅ Spins up Docker container with PocketBase
- ✅ Creates admin account with secure password
- ✅ Adds DNS record for `client1.yourdomain.com`
- ✅ Configures NGINX reverse proxy
- ✅ Updates Cloudflare Tunnel configuration
- ✅ Restarts services to apply changes

### **4. Access Your Instance:**
- **URL**: `http://client1.yourdomain.com`
- **Admin Panel**: `http://client1.yourdomain.com/_/`
- **Credentials**: `client1@example.com` / `[generated_password]`

## 📁 Project Structure

```
PocketFast/
├── deploy_pocketbase.sh    # Main deployment automation script
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile             # PocketBase container definition
├── package.json           # Node.js dependencies
├── data/                  # User data directories (auto-created)
│   ├── user1/            # Isolated data for user1
│   ├── user2/            # Isolated data for user2
│   └── ...
└── README.md             # This file
```

## 🔧 Configuration

### **Environment Variables:**
| Variable | Description | Example |
|----------|-------------|---------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token for DNS management | `abc123...` |
| `CLOUDFLARE_ZONE_ID` | Your Cloudflare zone ID | `f28cbc12...` |
| `CLOUDFLARE_TUNNEL_TARGET` | Cloudflare Tunnel target | `tunnel.cfargotunnel.com` |
| `DOMAIN` | Your main domain | `yourdomain.com` |

### **Port Management:**
- Each user gets a unique port (e.g., 8090, 8091, 8092)
- Ports are mapped to Docker containers
- NGINX routes traffic based on subdomain

## 🛡️ Security Features

- **Data Isolation**: Each user's data is completely separated
- **Random Passwords**: Secure admin passwords generated automatically
- **Environment Variables**: No hardcoded secrets
- **Network Isolation**: Each instance runs on its own port
- **Reverse Proxy**: Proper SSL termination and header handling

## 📊 Use Cases

### **SaaS Platform:**
```bash
# Deploy for different clients
./deploy_pocketbase.sh acme_corp 8090
./deploy_pocketbase.sh startup_inc 8091
./deploy_pocketbase.sh enterprise_llc 8092
```

### **Development Environment:**
```bash
# Deploy for different features
./deploy_pocketbase.sh feature_a 8090
./deploy_pocketbase.sh feature_b 8091
./deploy_pocketbase.sh testing 8092
```

### **Client Projects:**
```bash
# Deploy for different projects
./deploy_pocketbase.sh project_alpha 8090
./deploy_pocketbase.sh project_beta 8091
./deploy_pocketbase.sh project_gamma 8092
```

## 🔄 Management Commands

### **List Running Instances:**
```bash
docker ps --filter "name=pocketbase_"
```

### **Stop an Instance:**
```bash
docker stop pocketbase_username
```

### **Start an Instance:**
```bash
docker start pocketbase_username
```

### **Remove an Instance:**
```bash
docker rm -f pocketbase_username
rm -rf ./data/username
```

## 🚨 Troubleshooting

### **Common Issues:**

1. **Port Already in Use:**
   ```bash
   # Check what's using the port
   netstat -tulpn | grep :8090
   ```

2. **Cloudflare API Errors:**
   - Verify API token permissions
   - Check zone ID is correct
   - Ensure tunnel target is valid

3. **NGINX Configuration:**
   ```bash
   # Test configuration
   sudo nginx -t
   
   # Reload configuration
   sudo systemctl reload nginx
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

## 🆘 Support

If you encounter issues or have questions:
1. Check the troubleshooting section
2. Review Cloudflare and NGINX logs
3. Ensure all prerequisites are met
4. Verify environment variables are set correctly

---

**PocketFast** - Deploy PocketBase instances at lightning speed! ⚡
