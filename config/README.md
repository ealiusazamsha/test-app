# App Configuration

This directory contains configuration files for different environments.

## Environment Files

- `.env.example` - Template for environment variables
- `.env` - Local development environment (not committed)
- `.env.production` - Production environment variables (not committed)

## Adding New Configuration

1. Copy `.env.example` to `.env`
2. Fill in your actual credentials
3. For production, create `.env.production`

## Security Notes

- Never commit `.env` files with real credentials
- Use different credentials for development and production
- Rotate API keys regularly
- Keep Keycloak client secrets secure
