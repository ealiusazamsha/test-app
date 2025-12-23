class AppConstants {
  // App Information
  static const String appName = 'Test App';
  static const String appVersion = '1.0.0';
  
  // API Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userInfoKey = 'user_info';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // WordPress
  static const String wpApiVersion = 'wp/v2';
}
