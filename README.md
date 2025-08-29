# PocketFast - Secure Deployment

## ⚠️ SECURITY WARNING ⚠️

**IMPORTANT**: This project previously contained exposed API keys and sensitive information. These have been removed for security reasons.

## Setup Instructions

### 1. Environment Variables

Copy `env.example` to `.env` and fill in your actual values:

```bash
cp env.example .env
```

Edit `.env` with your actual credentials:

```bash
# Cloudflare API Configuration
CLOUDFLARE_API_TOKEN=your_actual_api_token
CLOUDFLARE_ZONE_ID=your_actual_zone_id
CLOUDFLARE_TUNNEL_TARGET=your_actual_tunnel_target
DOMAIN=your_actual_domain
```

### 2. Set Environment Variables

Before running the deployment script, set your environment variables:

```bash
export CLOUDFLARE_API_TOKEN="your_actual_api_token"
export CLOUDFLARE_ZONE_ID="your_actual_zone_id"
export CLOUDFLARE_TUNNEL_TARGET="your_actual_tunnel_target"
export DOMAIN="your_actual_domain"
```

### 3. Run Deployment

```bash
./deploy_pocketbase.sh username port_number
```

## Security Best Practices

- ✅ **Use environment variables** instead of hardcoded secrets
- ✅ **Never commit** `.env` files to version control
- ✅ **Add `.env`** to your `.gitignore` file
- ✅ **Rotate API keys** regularly
- ✅ **Use least privilege** for API tokens
- ❌ **Never hardcode** API keys in scripts
- ❌ **Never share** API keys publicly

## Files to Add to .gitignore

```
.env
*.env
data/
```

## Getting Your Cloudflare Credentials

1. **API Token**: https://dash.cloudflare.com/profile/api-tokens
2. **Zone ID**: https://dash.cloudflare.com/your-domain
3. **Tunnel Target**: Run `cloudflared tunnel list` in your terminal
