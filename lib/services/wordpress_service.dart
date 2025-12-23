import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/wordpress_post.dart';

class WordPressService {
  String get _wordpressUrl => dotenv.env['WORDPRESS_URL'] ?? '';
  String get _apiBase => dotenv.env['WORDPRESS_API_BASE'] ?? '/wp-json/wp/v2';
  
  String get _baseUrl => '$_wordpressUrl$_apiBase';

  /// Get posts from WordPress
  Future<List<WordPressPost>> getPosts({
    int page = 1,
    int perPage = 10,
    String? authToken,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/posts?page=$page&per_page=$perPage'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WordPressPost.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  /// Get a single post by ID
  Future<WordPressPost?> getPost(int postId, {String? authToken}) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return WordPressPost.fromJson(json.decode(response.body));
      } else {
        debugPrint('Failed to load post: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching post: $e');
      return null;
    }
  }

  /// Create a new post (requires authentication)
  Future<WordPressPost?> createPost({
    required String title,
    required String content,
    required String authToken,
    String status = 'draft',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'title': title,
          'content': content,
          'status': status,
        }),
      );

      if (response.statusCode == 201) {
        return WordPressPost.fromJson(json.decode(response.body));
      } else {
        debugPrint('Failed to create post: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating post: $e');
      return null;
    }
  }

  /// Get WordPress pages
  Future<List<dynamic>> getPages({
    int page = 1,
    int perPage = 10,
    String? authToken,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/pages?page=$page&per_page=$perPage'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('Failed to load pages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching pages: $e');
      return [];
    }
  }

  /// Get WordPress categories
  Future<List<dynamic>> getCategories({String? authToken}) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('Failed to load categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  /// Search WordPress content
  Future<List<dynamic>> search(String query, {String? authToken}) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/search?search=$query'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('Failed to search: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error searching: $e');
      return [];
    }
  }
}
