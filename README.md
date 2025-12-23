# Test App - Flutter Mobile Application

A Flutter mobile application with WordPress integration using Keycloak authentication and Digital Ocean deployment support.

## Features

- **Keycloak Authentication**: Secure authentication using Keycloak OAuth2/OpenID Connect
- **Demo Mode**: Test the app without configuring backend services
- **WordPress Integration**: Connect and interact with WordPress websites via REST API
- **Post Creation**: Create and publish WordPress posts from the app
- **Digital Ocean Support**: Integration with Digital Ocean API for infrastructure management
- **API Services**: Extensible API service layer with testing tools for external platforms
- **Profile Management**: Edit user profile information
- **Theme Customization**: Light, Dark, and System theme modes
- **Secure Storage**: Token management using Flutter Secure Storage
- **Modern UI**: Material Design 3 with responsive layouts
- **Back Navigation**: Intuitive navigation with back buttons on all screens

## Quick Start (Demo Mode)

Want to test the app immediately without setting up backend services?

1. **Clone and Install**
   ```bash
   git clone https://github.com/ealiusazamsha/test-app.git
   cd test-app
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Login with Demo Credentials**
   - Enter any username (e.g., "demo")
   - Enter any password (e.g., "password")
   - The app will automatically use demo mode!

**Demo Mode Features:**
- ✅ Works without backend configuration
- ✅ Demo authentication (any credentials work)
- ✅ Sample WordPress posts
- ✅ Sample Digital Ocean droplets
- ✅ Full UI navigation and features
- ℹ️ Demo mode indicators shown in the app

## Architecture

### Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── user.dart
│   └── wordpress_post.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── post_detail_screen.dart
│   ├── post_create_screen.dart
│   ├── profile_edit_screen.dart
│   ├── digital_ocean_screen.dart
│   ├── api_services_screen.dart
│   └── settings_screen.dart
├── services/                 # Business logic and API services
│   ├── auth_service.dart
│   ├── wordpress_service.dart
│   ├── api_service.dart
│   └── theme_service.dart
├── utils/                    # Utility classes
│   ├── constants.dart
│   └── logger.dart
└── widgets/                  # Reusable widgets
    ├── loading_widget.dart
    └── error_widget.dart
```

## Prerequisites

### For Demo Mode (No Setup Required)
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### For Production Use
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Xcode (for iOS development)
- Android Studio (for Android development)
- Keycloak server instance (optional - for real authentication)
- WordPress website with REST API enabled (optional - for real content)
- Digital Ocean account (optional - for infrastructure management)

## Setup Instructions

### Quick Demo Setup (Recommended for Testing)

1. **Clone the Repository**
   ```bash
   git clone https://github.com/ealiusazamsha/test-app.git
   cd test-app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Login**
   - Enter any username and password
   - App automatically runs in demo mode
   - Explore all features with sample data!

### Production Setup (With Real Backend Services)

### 1. Clone the Repository

```bash
git clone https://github.com/ealiusazamsha/test-app.git
cd test-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Copy the example environment file and configure with your credentials:

```bash
cp .env.example .env
```

Edit `.env` with your actual configuration:

```env
# Keycloak Configuration
KEYCLOAK_URL=https://your-keycloak-server.com
KEYCLOAK_REALM=your-realm
KEYCLOAK_CLIENT_ID=your-client-id
KEYCLOAK_CLIENT_SECRET=your-client-secret

# WordPress Configuration
WORDPRESS_URL=https://your-wordpress-site.com
WORDPRESS_API_BASE=/wp-json/wp/v2

# Digital Ocean Configuration
DIGITAL_OCEAN_API_URL=https://api.digitalocean.com/v2
DIGITAL_OCEAN_API_KEY=your-api-key

# Other API Endpoints
API_BASE_URL=https://your-api-server.com/api
```

### 4. Run the Application

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

#### Web
```bash
flutter run -d chrome
```

## Demo Mode vs Production Mode

### Demo Mode (Default)

The app automatically runs in **demo mode** when:
- No `.env` file is present, OR
- `.env` contains placeholder values (e.g., `your-keycloak-server.com`)

**What works in demo mode:**
- ✅ Login with any username/password
- ✅ View sample WordPress posts (3 demo posts)
- ✅ View sample Digital Ocean droplets (2 demo droplets)
- ✅ Full UI navigation and interaction
- ✅ All screens and features accessible
- ℹ️ Demo indicators shown in the UI

**Demo mode is perfect for:**
- Testing the app quickly
- Exploring UI/UX features
- Development without backend setup
- Demo presentations

### Production Mode

The app switches to **production mode** when:
- `.env` file exists with real backend URLs
- Keycloak URL doesn't contain placeholder text
- Client ID is configured properly

**Production mode features:**
- 🔐 Real Keycloak authentication
- 📝 Live WordPress content
- ☁️ Actual Digital Ocean droplets
- 🔒 Secure token management
- 🔄 Automatic token refresh

To switch from demo to production:
1. Create/edit `.env` file with real credentials
2. Rebuild the app: `flutter clean && flutter pub get`
3. Run the app again

## Keycloak Configuration

1. **Create a Realm** in your Keycloak admin console
2. **Create a Client**:
   - Client ID: Your app identifier
   - Client Protocol: openid-connect
   - Access Type: confidential
   - Valid Redirect URIs: Configure based on your app's deep links
3. **Enable Direct Access Grants** for username/password login
4. **Create Users** in the realm for testing

## WordPress Configuration

1. **Ensure REST API is enabled** (enabled by default in WordPress)
2. **Install Application Passwords plugin** (or use JWT authentication)
3. **Configure CORS** if needed for cross-origin requests
4. **Test API endpoint**: `https://your-site.com/wp-json/wp/v2/posts`

## Digital Ocean Integration

The app includes integration with Digital Ocean API for:
- Listing droplets
- Creating new droplets
- Managing account information
- Accessing infrastructure resources

Configure your Digital Ocean API token in the `.env` file.

## Key Services

### AuthService
Handles Keycloak authentication:
- Username/password login
- Token refresh
- Secure token storage
- User information retrieval
- Logout functionality

### WordPressService
Manages WordPress API interactions:
- Fetch posts and pages
- Create new content
- Search functionality
- Category management

### ApiService
Generic API client with:
- RESTful operations (GET, POST, PUT, DELETE)
- Digital Ocean API integration
- External service connections
- File upload support
- Request/response interceptors

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

Run tests with:
```bash
flutter test
```

## Dependencies

Key dependencies used in this project:
- `provider` - State management
- `http` & `dio` - HTTP clients
- `flutter_secure_storage` - Secure token storage
- `oauth2` & `jwt_decoder` - Authentication
- `flutter_dotenv` - Environment configuration
- `logger` - Logging

## Security Considerations

- All tokens are stored securely using FlutterSecureStorage
- Environment variables are not committed to version control
- HTTPS is required for all API communications
- JWT tokens are validated before use
- Automatic token refresh on expiration

## Troubleshooting

### Common Issues

1. **Build errors**: Run `flutter clean && flutter pub get`
2. **Environment variables not loading**: Ensure `.env` file exists in root directory
3. **Authentication fails**: Verify Keycloak configuration and credentials
4. **WordPress API errors**: Check API endpoint and permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Contact the development team

## Future Enhancements

- [ ] Biometric authentication
- [ ] Offline data synchronization
- [ ] Push notifications
- [ ] Multi-language support
- [ ] Dark mode support
- [ ] Advanced WordPress features (comments, media upload)
- [ ] More Digital Ocean operations
- [ ] Analytics integration