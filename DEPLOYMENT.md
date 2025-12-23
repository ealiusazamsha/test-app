# Deployment Guide

This guide covers deploying the Test App to production environments.

## Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Environment variables configured
- [ ] API endpoints tested
- [ ] Security audit completed
- [ ] App icons and splash screens added
- [ ] Privacy policy created
- [ ] Terms of service created
- [ ] App store assets prepared

## Environment Configuration

### Production Environment Variables

Create a `.env.production` file:

```env
# Production Keycloak
KEYCLOAK_URL=https://auth.production.com
KEYCLOAK_REALM=production-realm
KEYCLOAK_CLIENT_ID=production-client-id
KEYCLOAK_CLIENT_SECRET=production-secret

# Production WordPress
WORDPRESS_URL=https://production-wordpress.com
WORDPRESS_API_BASE=/wp-json/wp/v2

# Production Digital Ocean
DIGITAL_OCEAN_API_URL=https://api.digitalocean.com/v2
DIGITAL_OCEAN_API_KEY=production-api-key

# Production API
API_BASE_URL=https://api.production.com
```

## Building for Production

### Android

#### 1. Configure Signing

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

#### 2. Build Release APK

```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

#### 3. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

#### 1. Configure Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner > Signing & Capabilities
3. Select your team
4. Configure provisioning profile

#### 2. Build Release

```bash
flutter build ios --release
```

#### 3. Archive in Xcode

1. Open Xcode
2. Product > Archive
3. Upload to App Store Connect

## App Store Deployment

### Google Play Store

#### Requirements

- [ ] Google Play Developer account ($25 one-time fee)
- [ ] App signed with release key
- [ ] App icons (512x512 and adaptive icons)
- [ ] Screenshots (multiple device sizes)
- [ ] Feature graphic (1024x500)
- [ ] Privacy policy URL
- [ ] Content rating questionnaire completed

#### Steps

1. **Create App in Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create application
   - Fill in app details

2. **Upload App Bundle**
   - Navigate to Release > Production
   - Create new release
   - Upload AAB file
   - Add release notes

3. **Complete Store Listing**
   - App title and description
   - Screenshots and graphics
   - Categorization
   - Contact details

4. **Set Pricing & Distribution**
   - Free or paid
   - Country availability
   - Content rating

5. **Submit for Review**
   - Review all sections
   - Submit for review
   - Wait for approval (typically 1-3 days)

### Apple App Store

#### Requirements

- [ ] Apple Developer account ($99/year)
- [ ] App signed with distribution certificate
- [ ] App icons (1024x1024)
- [ ] Screenshots (multiple device sizes)
- [ ] App preview video (optional)
- [ ] Privacy policy URL
- [ ] App Store description

#### Steps

1. **Create App in App Store Connect**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Create new app
   - Fill in app information

2. **Configure App**
   - App name and bundle ID
   - Primary language
   - Category
   - Age rating

3. **Upload Build**
   - Use Xcode to archive and upload
   - Or use Application Loader
   - Wait for processing (15-30 minutes)

4. **Complete App Information**
   - Screenshots
   - Description
   - Keywords
   - Support URL
   - Marketing URL
   - Privacy policy URL

5. **Submit for Review**
   - Select build
   - Add release notes
   - Submit for review
   - Wait for approval (typically 1-3 days)

## Backend Deployment

### Keycloak Setup

1. **Deploy Keycloak**
   - Use Docker: `docker run -p 8080:8080 quay.io/keycloak/keycloak`
   - Or use managed service
   - Or deploy to cloud (AWS, GCP, Azure)

2. **Configure Realm**
   ```bash
   # Create realm
   # Add clients
   # Configure client settings
   # Add users
   # Set up roles and permissions
   ```

3. **SSL/TLS Configuration**
   - Enable HTTPS
   - Configure certificates
   - Update redirect URLs

### WordPress Deployment

1. **Deploy WordPress**
   - Use hosting provider (WP Engine, Kinsta, etc.)
   - Or self-host on VPS
   - Or use managed WordPress hosting

2. **Enable REST API**
   - WordPress REST API enabled by default
   - Install authentication plugin if needed
   - Configure CORS if necessary

3. **Security**
   - Enable HTTPS
   - Configure authentication
   - Set up rate limiting
   - Enable security plugins

### Digital Ocean Setup

1. **Create API Token**
   - Go to Digital Ocean control panel
   - API > Generate New Token
   - Set read/write permissions

2. **Configure Backend Proxy (Recommended)**
   ```javascript
   // Example Node.js proxy
   app.post('/api/droplets/create', authenticateUser, async (req, res) => {
     const response = await axios.post(
       'https://api.digitalocean.com/v2/droplets',
       req.body,
       {
         headers: {
           'Authorization': `Bearer ${process.env.DO_API_KEY}`,
         },
       }
     );
     res.json(response.data);
   });
   ```

## CI/CD Pipeline

### GitHub Actions

The included workflow (`.github/workflows/flutter-ci.yml`) provides:
- Automated testing
- Code analysis
- Build artifacts

#### Extending for Deployment

Add deployment steps:

```yaml
- name: Deploy to Firebase
  uses: w9jds/firebase-action@master
  with:
    args: deploy --only hosting
  env:
    FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### Fastlane (Advanced)

Install Fastlane for automated deployment:

```bash
# Install Fastlane
sudo gem install fastlane

# Initialize
cd android && fastlane init
cd ../ios && fastlane init
```

Configure `Fastfile`:

```ruby
# Android
lane :deploy do
  gradle(task: "bundle", build_type: "Release")
  upload_to_play_store(
    track: 'production',
    aab: 'app/build/outputs/bundle/release/app-release.aab'
  )
end

# iOS
lane :deploy do
  build_app(scheme: "Runner")
  upload_to_app_store
end
```

## Monitoring & Analytics

### Crash Reporting

#### Sentry Integration

```yaml
# pubspec.yaml
dependencies:
  sentry_flutter: ^7.0.0
```

```dart
// main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

### Analytics

#### Firebase Analytics

```yaml
# pubspec.yaml
dependencies:
  firebase_analytics: ^10.0.0
```

```dart
// Initialize
final analytics = FirebaseAnalytics.instance;

// Log events
await analytics.logEvent(
  name: 'login',
  parameters: {'method': 'keycloak'},
);
```

## Performance Optimization

### Code Optimization

1. **Enable Obfuscation**
   ```bash
   flutter build apk --release --obfuscate --split-debug-info=./debug-info
   ```

2. **Reduce App Size**
   - Remove unused resources
   - Compress images
   - Use vector graphics
   - Split APKs by ABI

3. **Optimize Images**
   ```bash
   # Use WebP format
   cwebp input.png -o output.webp
   ```

### Network Optimization

1. **Enable HTTP/2**
2. **Implement caching**
3. **Compress responses**
4. **Use CDN for static assets**

## Security Hardening

### Release Build Security

1. **Code Obfuscation**: Enabled in build commands
2. **Certificate Pinning**: Implement for production APIs
3. **Root Detection**: Add for banking-level security
4. **Jailbreak Detection**: iOS security

### API Security

1. **Rate Limiting**: Implement on backend
2. **API Keys**: Rotate regularly
3. **Audit Logs**: Enable on all APIs
4. **Monitoring**: Set up alerts for suspicious activity

## Rollback Strategy

### Version Management

1. **Keep Previous Versions**
   - Store APK/IPA files
   - Maintain build artifacts
   - Document changes

2. **Staged Rollout**
   - Release to 10% of users first
   - Monitor for issues
   - Gradually increase to 100%

3. **Emergency Rollback**
   - Play Store: Revert to previous version
   - App Store: Pull update, submit previous version

## Post-Deployment

### Monitoring

- [ ] Set up crash reporting
- [ ] Configure analytics
- [ ] Monitor API usage
- [ ] Track user feedback
- [ ] Monitor performance metrics

### Updates

- [ ] Plan update schedule
- [ ] Monitor user reviews
- [ ] Track feature requests
- [ ] Fix critical bugs promptly
- [ ] Regular security updates

## Checklist

### Pre-Launch
- [ ] All features tested
- [ ] Performance optimized
- [ ] Security audit completed
- [ ] Privacy policy in place
- [ ] Store listings complete
- [ ] Marketing materials ready

### Launch Day
- [ ] Monitor crash reports
- [ ] Watch user reviews
- [ ] Check analytics
- [ ] Be ready for hotfix
- [ ] Respond to user feedback

### Post-Launch
- [ ] Address critical issues
- [ ] Plan updates
- [ ] Analyze metrics
- [ ] Gather feedback
- [ ] Plan new features

## Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://developer.apple.com/app-store-connect/)
- [Fastlane Docs](https://docs.fastlane.tools/)

## Support

For deployment issues:
- Check documentation
- Review build logs
- Consult platform-specific guides
- Contact platform support

---

**Last Updated**: 2024-12-23
