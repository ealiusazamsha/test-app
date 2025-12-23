# Flutter Project Configuration

## Development Environment

This Flutter project is set up for mobile app development with the following requirements:

### Flutter Version
- Flutter SDK: >=3.0.0
- Dart SDK: >=3.0.0

### IDE Configuration

#### VS Code
Recommended extensions:
- Flutter
- Dart
- Flutter Widget Snippets

#### Android Studio
- Flutter plugin
- Dart plugin

### Build Configuration

#### Android
- Min SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Compile SDK: 34

#### iOS
- Minimum iOS Version: 12.0
- Swift Version: 5.0

## Environment Setup

Before running the app, ensure you have:
1. Created a `.env` file based on `.env.example`
2. Configured Keycloak realm and client
3. Set up WordPress API access
4. Obtained Digital Ocean API credentials (optional)

## Running the App

Development mode:
```bash
flutter run --dart-define-from-file=.env
```

Debug build:
```bash
flutter run --debug
```

Release build:
```bash
flutter run --release
```

## Code Quality

### Linting
```bash
flutter analyze
```

### Formatting
```bash
flutter format .
```

### Testing
```bash
flutter test
```

### Coverage
```bash
flutter test --coverage
```

## Common Commands

### Clean build
```bash
flutter clean
flutter pub get
```

### Update dependencies
```bash
flutter pub upgrade
```

### Generate code (if using code generation)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Debugging

Enable verbose logging:
```bash
flutter run -v
```

View logs:
```bash
flutter logs
```

## Platform-Specific Notes

### Android
- Ensure `local.properties` is configured with your Android SDK path
- For physical device testing, enable USB debugging

### iOS
- Requires macOS with Xcode installed
- Set up code signing in Xcode
- Run `pod install` in the ios/ directory if needed

### Web
```bash
flutter run -d chrome
```

## Troubleshooting

### Issue: Dependencies not resolving
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### Issue: iOS build fails
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
```

### Issue: Android build fails
- Check Android SDK installation
- Verify ANDROID_HOME environment variable
- Update Gradle if prompted

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [WordPress REST API](https://developer.wordpress.org/rest-api/)
- [Digital Ocean API](https://docs.digitalocean.com/reference/api/)
