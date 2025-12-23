import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late Dio _dio;
  
  String get _apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  String get _digitalOceanUrl => dotenv.env['DIGITAL_OCEAN_API_URL'] ?? '';
  String get _digitalOceanApiKey => dotenv.env['DIGITAL_OCEAN_API_KEY'] ?? '';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('API Request: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('API Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Set authorization token for API calls
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Generic GET request
  Future<Response?> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        '$_apiBaseUrl$endpoint',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      debugPrint('GET request error: $e');
      return null;
    }
  }

  /// Generic POST request
  Future<Response?> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(
        '$_apiBaseUrl$endpoint',
        data: data,
      );
      return response;
    } catch (e) {
      debugPrint('POST request error: $e');
      return null;
    }
  }

  /// Generic PUT request
  Future<Response?> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(
        '$_apiBaseUrl$endpoint',
        data: data,
      );
      return response;
    } catch (e) {
      debugPrint('PUT request error: $e');
      return null;
    }
  }

  /// Generic DELETE request
  Future<Response?> delete(String endpoint) async {
    try {
      final response = await _dio.delete('$_apiBaseUrl$endpoint');
      return response;
    } catch (e) {
      debugPrint('DELETE request error: $e');
      return null;
    }
  }

  // Digital Ocean specific methods

  /// Get Digital Ocean droplets
  Future<List<dynamic>> getDroplets() async {
    try {
      final response = await _dio.get(
        '$_digitalOceanUrl/droplets',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_digitalOceanApiKey',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return response.data['droplets'] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching droplets: $e');
      return [];
    }
  }

  /// Get Digital Ocean account information
  Future<Map<String, dynamic>?> getAccountInfo() async {
    try {
      final response = await _dio.get(
        '$_digitalOceanUrl/account',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_digitalOceanApiKey',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return response.data['account'];
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching account info: $e');
      return null;
    }
  }

  /// Create a new droplet
  Future<Map<String, dynamic>?> createDroplet({
    required String name,
    required String region,
    required String size,
    required String image,
  }) async {
    try {
      final response = await _dio.post(
        '$_digitalOceanUrl/droplets',
        data: {
          'name': name,
          'region': region,
          'size': size,
          'image': image,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_digitalOceanApiKey',
          },
        ),
      );
      
      if (response.statusCode == 201) {
        return response.data['droplet'];
      }
      return null;
    } catch (e) {
      debugPrint('Error creating droplet: $e');
      return null;
    }
  }

  /// Call external API service
  Future<Response?> callExternalService(
    String baseUrl,
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: headers,
      );

      final response = await _dio.request(
        '$baseUrl$endpoint',
        data: data,
        options: options,
      );
      
      return response;
    } catch (e) {
      debugPrint('External service call error: $e');
      return null;
    }
  }

  /// Upload file to API
  Future<Response?> uploadFile(String endpoint, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '$_apiBaseUrl$endpoint',
        data: formData,
      );
      
      return response;
    } catch (e) {
      debugPrint('File upload error: $e');
      return null;
    }
  }
}
