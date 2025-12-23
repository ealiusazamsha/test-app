import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/models/user.dart';
import 'package:test_app/models/wordpress_post.dart';

void main() {
  group('User Model Tests', () {
    test('User should be created from JSON', () {
      final json = {
        'sub': '123',
        'preferred_username': 'testuser',
        'email': 'test@example.com',
        'given_name': 'Test',
        'family_name': 'User',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.firstName, 'Test');
      expect(user.lastName, 'User');
      expect(user.fullName, 'Test User');
    });

    test('User fullName should return username if names are null', () {
      final json = {
        'sub': '123',
        'preferred_username': 'testuser',
        'email': 'test@example.com',
      };

      final user = User.fromJson(json);

      expect(user.fullName, 'testuser');
    });
  });

  group('WordPress Post Model Tests', () {
    test('WordPressPost should be created from JSON', () {
      final json = {
        'id': 1,
        'title': {'rendered': 'Test Post'},
        'content': {'rendered': '<p>Test content</p>'},
        'excerpt': {'rendered': '<p>Test excerpt</p>'},
        'date': '2024-01-01T00:00:00',
        'status': 'publish',
        'link': 'https://example.com/post',
        'author': 1,
      };

      final post = WordPressPost.fromJson(json);

      expect(post.id, 1);
      expect(post.title, 'Test Post');
      expect(post.content, '<p>Test content</p>');
      expect(post.excerpt, '<p>Test excerpt</p>');
      expect(post.status, 'publish');
    });

    test('WordPressPost should convert to JSON', () {
      final post = WordPressPost(
        id: 1,
        title: 'Test Post',
        content: 'Test content',
        excerpt: 'Test excerpt',
        date: '2024-01-01T00:00:00',
        status: 'publish',
        link: 'https://example.com/post',
        authorId: 1,
      );

      final json = post.toJson();

      expect(json['id'], 1);
      expect(json['title']['rendered'], 'Test Post');
      expect(json['content']['rendered'], 'Test content');
      expect(json['status'], 'publish');
    });
  });
}
