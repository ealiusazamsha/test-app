# Security Guidelines

This document outlines security best practices and guidelines for the Test App.

## Authentication & Authorization

### Keycloak Integration

1. **Token Storage**
   - All tokens are stored securely using `FlutterSecureStorage`
   - Tokens are encrypted at rest on the device
   - Never log tokens or credentials

2. **Token Lifecycle**
   - Access tokens have limited lifetime
   - Automatic refresh using refresh tokens
   - Logout clears all tokens from secure storage

3. **Password Handling**
   - Passwords are never stored locally
   - Passwords are transmitted only over HTTPS
   - Use strong password policies in Keycloak

### Best Practices

```dart
// ✅ GOOD: Use secure storage
await _storage.write(key: 'access_token', value: token);

// ❌ BAD: Never store in SharedPreferences
// await prefs.setString('access_token', token); // INSECURE!

// ❌ BAD: Never log sensitive data
// print('Token: $token'); // NEVER DO THIS!
```

## API Security

### HTTPS Only

All API communications MUST use HTTPS:

```dart
// ✅ GOOD
const apiUrl = 'https://api.example.com';

// ❌ BAD
// const apiUrl = 'http://api.example.com'; // INSECURE!
```

### Request Headers

Always include proper authentication headers:

```dart
final headers = {
  'Authorization': 'Bearer $accessToken',
  'Content-Type': 'application/json',
};
```

### Token Validation

Validate tokens before use:

```dart
if (_accessToken != null && !JwtDecoder.isExpired(_accessToken!)) {
  // Token is valid, proceed
} else {
  // Token expired, refresh or logout
  await refreshAccessToken();
}
```

## Environment Variables

### Never Commit Secrets

1. **Use `.env` files** for local development
2. **Add `.env` to `.gitignore`**
3. **Use environment-specific files**:
   - `.env` - local development (not committed)
   - `.env.example` - template (committed)
   - `.env.production` - production (not committed)

### Example Structure

```env
# ✅ GOOD: Use placeholder values in .env.example
KEYCLOAK_CLIENT_SECRET=your-client-secret-here

# ❌ BAD: Never commit real secrets
# KEYCLOAK_CLIENT_SECRET=abc123def456 # REAL SECRET!
```

### Accessing Environment Variables

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Load environment
await dotenv.load(fileName: ".env");

// Access variables
final secret = dotenv.env['KEYCLOAK_CLIENT_SECRET'];
```

## Data Protection

### Sensitive Data

1. **User Information**
   - Store minimal user data
   - Encrypt sensitive fields
   - Clear on logout

2. **API Keys**
   - Never hardcode API keys
   - Use environment variables
   - Rotate keys regularly

3. **Personal Data**
   - Follow GDPR/privacy regulations
   - Implement data deletion
   - Provide data export options

### Encryption

```dart
// Use FlutterSecureStorage for sensitive data
final storage = FlutterSecureStorage();

// Store encrypted
await storage.write(key: 'sensitive_data', value: data);

// Read decrypted
final data = await storage.read(key: 'sensitive_data');

// Delete when no longer needed
await storage.delete(key: 'sensitive_data');
```

## Network Security

### Certificate Pinning (Advanced)

For production apps, implement certificate pinning:

```dart
// Example with Dio
final dio = Dio();
dio.httpClientAdapter = IOHttpClientAdapter(
  onHttpClientCreate: (client) {
    client.badCertificateCallback = 
        (X509Certificate cert, String host, int port) {
      // Verify certificate
      return cert.sha1.toString() == expectedFingerprint;
    };
    return client;
  },
);
```

### Timeout Configuration

Set appropriate timeouts to prevent hanging:

```dart
final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ),
);
```

## Input Validation

### Sanitize User Input

Always validate and sanitize user input:

```dart
String sanitizeInput(String input) {
  // Remove potentially harmful characters
  return input
      .replaceAll(RegExp(r'[<>]'), '')
      .trim();
}

// Use in forms
final sanitizedUsername = sanitizeInput(usernameController.text);
```

### Form Validation

```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    if (value.length < 3) {
      return 'Must be at least 3 characters';
    }
    // Additional validation
    return null;
  },
);
```

## WordPress Integration Security

### Authentication

Prefer OAuth/JWT over basic authentication:

```dart
// ✅ GOOD: Use Bearer token
headers: {
  'Authorization': 'Bearer $token',
}

// ❌ AVOID: Basic auth (if possible)
// 'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}'
```

### Content Sanitization

Sanitize HTML content from WordPress:

```dart
import 'package:html/parser.dart' show parse;

String sanitizeHtml(String html) {
  final document = parse(html);
  // Remove scripts and potentially harmful elements
  document.querySelectorAll('script').forEach((e) => e.remove());
  document.querySelectorAll('iframe').forEach((e) => e.remove());
  return document.body?.text ?? '';
}
```

## Digital Ocean API Security

### API Token Protection

1. **Never expose API tokens** in client code
2. **Use a backend proxy** for sensitive operations
3. **Implement rate limiting**

### Recommended Architecture

```
Mobile App → Backend API → Digital Ocean API
```

The mobile app should call your backend, which then calls Digital Ocean:

```dart
// ✅ GOOD: Call your backend
final response = await apiService.post(
  '/api/droplets/create',
  data: dropletConfig,
);

// ❌ BAD: Direct Digital Ocean API call from mobile
// Exposes your DO API token in the app!
```

## Code Security

### Obfuscation

Enable code obfuscation for release builds:

```bash
flutter build apk --obfuscate --split-debug-info=./debug-info
```

### ProGuard (Android)

Enable ProGuard in `android/app/build.gradle`:

```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

## Dependency Security

### Regular Updates

Keep dependencies up to date:

```bash
flutter pub upgrade
```

### Audit Dependencies

Check for known vulnerabilities:

```bash
flutter pub outdated
```

### Use Trusted Packages

- Check package popularity and maintenance
- Review package source code for sensitive operations
- Use packages from verified publishers

## Security Checklist

Before deploying to production:

- [ ] All secrets moved to environment variables
- [ ] HTTPS enforced for all API calls
- [ ] Tokens stored in secure storage
- [ ] Input validation implemented
- [ ] Error messages don't expose sensitive info
- [ ] Code obfuscation enabled
- [ ] Certificate pinning implemented (if needed)
- [ ] Dependencies updated and audited
- [ ] Security testing completed
- [ ] Privacy policy implemented
- [ ] Data encryption at rest
- [ ] Secure logout implemented
- [ ] Session timeout configured

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email security concerns to: security@example.com
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Compliance

### GDPR Compliance

- Implement data deletion
- Provide data export
- Show privacy policy
- Get user consent
- Implement right to be forgotten

### App Store Requirements

- Include privacy policy
- Declare data collection
- Implement parental controls (if applicable)
- Follow platform-specific guidelines

## Additional Resources

- [OWASP Mobile Security Project](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Keycloak Security Documentation](https://www.keycloak.org/docs/latest/securing_apps/)
- [WordPress Security](https://wordpress.org/support/article/hardening-wordpress/)

## Review Schedule

Security guidelines should be reviewed:
- Quarterly
- When adding new features
- After security incidents
- When dependencies are updated

---

**Last Updated**: 2024-12-23
**Next Review**: 2025-03-23
