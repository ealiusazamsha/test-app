import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  String? _accessToken;
  String? _refreshToken;
  Map<String, dynamic>? _userInfo;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userInfo => _userInfo;
  String? get accessToken => _accessToken;

  // Keycloak Configuration
  String get _keycloakUrl => dotenv.env['KEYCLOAK_URL'] ?? '';
  String get _realm => dotenv.env['KEYCLOAK_REALM'] ?? '';
  String get _clientId => dotenv.env['KEYCLOAK_CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['KEYCLOAK_CLIENT_SECRET'] ?? '';

  String get _tokenEndpoint => 
      '$_keycloakUrl/realms/$_realm/protocol/openid-connect/token';
  String get _userInfoEndpoint => 
      '$_keycloakUrl/realms/$_realm/protocol/openid-connect/userinfo';
  String get _logoutEndpoint => 
      '$_keycloakUrl/realms/$_realm/protocol/openid-connect/logout';

  AuthService() {
    _loadStoredTokens();
  }

  /// Load stored tokens on initialization
  Future<void> _loadStoredTokens() async {
    try {
      _accessToken = await _storage.read(key: 'access_token');
      _refreshToken = await _storage.read(key: 'refresh_token');
      
      if (_accessToken != null && !JwtDecoder.isExpired(_accessToken!)) {
        await _loadUserInfo();
        _isAuthenticated = true;
        notifyListeners();
      } else if (_refreshToken != null) {
        await refreshAccessToken();
      }
    } catch (e) {
      debugPrint('Error loading stored tokens: $e');
    }
  }

  /// Login with username and password
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'username': username,
          'password': password,
          'scope': 'openid profile email',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];

        // Store tokens securely
        await _storage.write(key: 'access_token', value: _accessToken);
        await _storage.write(key: 'refresh_token', value: _refreshToken);

        await _loadUserInfo();
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        debugPrint('Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Refresh access token using refresh token
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'refresh_token': _refreshToken!,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _refreshToken = data['refresh_token'];

        await _storage.write(key: 'access_token', value: _accessToken);
        await _storage.write(key: 'refresh_token', value: _refreshToken);

        await _loadUserInfo();
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
      await logout();
      return false;
    }
  }

  /// Load user information from Keycloak
  Future<void> _loadUserInfo() async {
    if (_accessToken == null) return;

    try {
      final response = await http.get(
        Uri.parse(_userInfoEndpoint),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        _userInfo = json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  /// Logout and clear tokens
  Future<void> logout() async {
    try {
      if (_refreshToken != null) {
        await http.post(
          Uri.parse(_logoutEndpoint),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'client_id': _clientId,
            'client_secret': _clientSecret,
            'refresh_token': _refreshToken!,
          },
        );
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _accessToken = null;
      _refreshToken = null;
      _userInfo = null;
      _isAuthenticated = false;

      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      
      notifyListeners();
    }
  }

  /// Get authorization header for API calls
  Map<String, String> getAuthHeaders() {
    if (_accessToken != null) {
      return {'Authorization': 'Bearer $_accessToken'};
    }
    return {};
  }
}
