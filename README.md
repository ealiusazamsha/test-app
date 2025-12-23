# Test App - Flutter Mobile Application

A Flutter mobile application with WordPress integration using Keycloak authentication and Digital Ocean deployment support.

## Features

- **Keycloak Authentication**: Secure authentication using Keycloak OAuth2/OpenID Connect
- **WordPress Integration**: Connect and interact with WordPress websites via REST API
- **Digital Ocean Support**: Integration with Digital Ocean API for infrastructure management
- **API Services**: Extensible API service layer for connecting to multiple platforms
- **Secure Storage**: Token management using Flutter Secure Storage
- **Modern UI**: Material Design 3 with responsive layouts

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
│   └── home_screen.dart
├── services/                 # Business logic and API services
│   ├── auth_service.dart
│   ├── wordpress_service.dart
│   └── api_service.dart
├── utils/                    # Utility classes
│   ├── constants.dart
│   └── logger.dart
└── widgets/                  # Reusable widgets
    ├── loading_widget.dart
    └── error_widget.dart
```

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Xcode (for iOS development)
- Android Studio (for Android development)
- Keycloak server instance
- WordPress website with REST API enabled

## Setup Instructions

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