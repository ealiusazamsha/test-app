# Quick Start Guide

Get up and running with Test App in **under 1 minute**!

## 🚀 Super Quick Start (Demo Mode)

**No setup required!** Just run and explore:

```bash
git clone https://github.com/ealiusazamsha/test-app.git
cd test-app
flutter pub get
flutter run
```

**Login with ANY credentials:**
- Username: `demo` (or anything)
- Password: `password` (or anything)

**That's it!** The app runs in demo mode with sample data.

## What You Get in Demo Mode

✅ **Full App Features:**
- Login functionality
- 3 sample WordPress posts
- 2 sample Digital Ocean droplets
- Complete navigation
- All UI screens accessible

✅ **No Backend Required:**
- No Keycloak server needed
- No WordPress site needed
- No Digital Ocean account needed
- Perfect for testing and demos!

## Want Real Backend Integration?

### Prerequisites for Production

- Flutter SDK (3.0.0 or higher)
- Git
- A code editor (VS Code or Android Studio recommended)
- Keycloak server (optional - for real authentication)
- WordPress website (optional - for real content)

## Installation Steps for Production

### 1. Clone the Repository

```bash
git clone https://github.com/ealiusazamsha/test-app.git
cd test-app
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Environment (Optional for Demo)

**For Demo Mode:** Skip this step! The app works without configuration.

**For Production Mode:**

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` with your actual credentials:

```env
KEYCLOAK_URL=https://your-keycloak-server.com
KEYCLOAK_REALM=your-realm
KEYCLOAK_CLIENT_ID=your-client-id
KEYCLOAK_CLIENT_SECRET=your-client-secret
WORDPRESS_URL=https://your-wordpress-site.com
```

### 4. Run the App

For Android:
```bash
flutter run -d android
```

For iOS (macOS only):
```bash
flutter run -d ios
```

For Web:
```bash
flutter run -d chrome
```

## First Time Setup

### Keycloak Configuration

1. Access your Keycloak admin console
2. Create a new realm (or use existing)
3. Create a client:
   - Client ID: `test-app`
   - Client Protocol: `openid-connect`
   - Access Type: `confidential`
   - Standard Flow Enabled: `ON`
   - Direct Access Grants Enabled: `ON`
4. Save and note the client secret
5. Create a test user in the realm

### WordPress Setup

1. Ensure your WordPress site is accessible
2. Verify REST API is enabled (default in WordPress)
3. Test the endpoint: `https://yoursite.com/wp-json/wp/v2/posts`

## Testing the App

### Login

1. Launch the app
2. You'll see a splash screen
3. Enter your Keycloak credentials:
   - Username: Your Keycloak username
   - Password: Your Keycloak password
4. Click "Login"

### Features to Try

1. **Posts Tab**: View WordPress posts
2. **Services Tab**: Access different services
3. **Profile Tab**: View your profile and logout

## Development Mode

### Hot Reload

While the app is running, make changes to the code and press:
- `r` in terminal for hot reload
- `R` for hot restart

### Debug Mode

Run with verbose logging:
```bash
flutter run -v
```

## Common Issues

### Issue: "Flutter SDK not found"
**Solution**: Install Flutter SDK and add to PATH

### Issue: "Dependencies error"
**Solution**: 
```bash
flutter clean
flutter pub get
```

### Issue: "Login fails"
**Solution**: 
- Verify Keycloak URL is correct
- Check realm name
- Ensure client ID and secret are correct
- Verify user exists in Keycloak

### Issue: "No posts displayed"
**Solution**:
- Check WordPress URL
- Ensure REST API is enabled
- Verify network connectivity

## Next Steps

- [ ] Customize the UI in `lib/screens/`
- [ ] Add more services in `lib/services/`
- [ ] Configure Digital Ocean API
- [ ] Set up production environment
- [ ] Deploy to app stores

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [WordPress REST API](https://developer.wordpress.org/rest-api/)
- [Project README](README.md)
- [Development Guide](DEVELOPMENT.md)

## Getting Help

- Check [Issues](https://github.com/ealiusazamsha/test-app/issues)
- Read [Contributing Guide](CONTRIBUTING.md)
- Contact the development team

---

**Happy Coding!** 🚀
