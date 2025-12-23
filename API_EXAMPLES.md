# API Usage Examples

This document provides examples of how to use the various services in the Test App.

## Authentication Service

### Login

```dart
import 'package:provider/provider.dart';
import 'package:test_app/services/auth_service.dart';

// In your widget
final authService = Provider.of<AuthService>(context, listen: false);

// Perform login
bool success = await authService.login('username', 'password');

if (success) {
  // Login successful
  print('User logged in: ${authService.userInfo}');
} else {
  // Login failed
  print('Login failed');
}
```

### Check Authentication Status

```dart
final authService = Provider.of<AuthService>(context);

if (authService.isAuthenticated) {
  // User is logged in
  final userInfo = authService.userInfo;
  print('User email: ${userInfo?['email']}');
}
```

### Logout

```dart
await authService.logout();
Navigator.pushReplacementNamed(context, '/login');
```

### Get Auth Headers

```dart
final headers = authService.getAuthHeaders();
// Use headers in API calls
```

## WordPress Service

### Fetch Posts

```dart
import 'package:provider/provider.dart';
import 'package:test_app/services/wordpress_service.dart';
import 'package:test_app/services/auth_service.dart';

final wordpressService = Provider.of<WordPressService>(context, listen: false);
final authService = Provider.of<AuthService>(context, listen: false);

// Get posts
final posts = await wordpressService.getPosts(
  page: 1,
  perPage: 10,
  authToken: authService.accessToken,
);

for (var post in posts) {
  print('Post: ${post.title}');
}
```

### Get Single Post

```dart
final post = await wordpressService.getPost(
  123, // Post ID
  authToken: authService.accessToken,
);

if (post != null) {
  print('Title: ${post.title}');
  print('Content: ${post.content}');
}
```

### Create Post

```dart
final newPost = await wordpressService.createPost(
  title: 'My New Post',
  content: '<p>This is the content of my post.</p>',
  authToken: authService.accessToken!,
  status: 'draft', // or 'publish'
);

if (newPost != null) {
  print('Post created with ID: ${newPost.id}');
}
```

### Search WordPress

```dart
final results = await wordpressService.search(
  'search query',
  authToken: authService.accessToken,
);

for (var result in results) {
  print('Found: ${result['title']}');
}
```

## API Service

### Basic GET Request

```dart
import 'package:provider/provider.dart';
import 'package:test_app/services/api_service.dart';

final apiService = Provider.of<ApiService>(context, listen: false);

// Set auth token
apiService.setAuthToken(authService.accessToken!);

// Make GET request
final response = await apiService.get('/users');

if (response != null && response.statusCode == 200) {
  final users = response.data;
  print('Users: $users');
}
```

### POST Request

```dart
final response = await apiService.post(
  '/users',
  data: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
);

if (response != null && response.statusCode == 201) {
  print('User created: ${response.data}');
}
```

### PUT Request

```dart
final response = await apiService.put(
  '/users/123',
  data: {
    'name': 'Jane Doe',
  },
);
```

### DELETE Request

```dart
final response = await apiService.delete('/users/123');

if (response != null && response.statusCode == 200) {
  print('User deleted');
}
```

### Digital Ocean - List Droplets

```dart
final droplets = await apiService.getDroplets();

for (var droplet in droplets) {
  print('Droplet: ${droplet['name']}');
}
```

### Digital Ocean - Create Droplet

```dart
final droplet = await apiService.createDroplet(
  name: 'my-droplet',
  region: 'nyc3',
  size: 's-1vcpu-1gb',
  image: 'ubuntu-20-04-x64',
);

if (droplet != null) {
  print('Droplet created: ${droplet['name']}');
}
```

### Call External Service

```dart
final response = await apiService.callExternalService(
  'https://api.example.com',
  '/endpoint',
  method: 'POST',
  data: {'key': 'value'},
  headers: {'Custom-Header': 'value'},
);
```

### Upload File

```dart
final response = await apiService.uploadFile(
  '/upload',
  '/path/to/file.jpg',
);

if (response != null && response.statusCode == 200) {
  print('File uploaded: ${response.data}');
}
```

## Complete Example: Fetching and Displaying Posts

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/wordpress_service.dart';
import 'package:test_app/services/auth_service.dart';
import 'package:test_app/models/wordpress_post.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<WordPressPost> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    final wordpressService = Provider.of<WordPressService>(
      context,
      listen: false,
    );
    final authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    final posts = await wordpressService.getPosts(
      authToken: authService.accessToken,
    );

    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.excerpt),
          onTap: () {
            // Navigate to post detail
          },
        );
      },
    );
  }
}
```

## Error Handling

### With Try-Catch

```dart
try {
  final posts = await wordpressService.getPosts();
  // Use posts
} catch (e) {
  print('Error fetching posts: $e');
  // Show error message to user
}
```

### Check Response

```dart
final response = await apiService.get('/endpoint');

if (response != null) {
  if (response.statusCode == 200) {
    // Success
    final data = response.data;
  } else {
    // Error
    print('Error: ${response.statusCode}');
  }
} else {
  // Network error
  print('Network error');
}
```

## Best Practices

1. **Always handle errors**: Services may fail due to network issues
2. **Check authentication**: Ensure user is authenticated before API calls
3. **Use loading states**: Show loading indicators during API calls
4. **Cache data**: Store frequently accessed data locally
5. **Refresh tokens**: Handle token expiration gracefully

## Advanced Usage

### Custom Interceptors

```dart
// In ApiService initialization
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Modify request before sending
      options.headers['Custom-Header'] = 'value';
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Process response
      return handler.next(response);
    },
    onError: (error, handler) {
      // Handle errors globally
      if (error.response?.statusCode == 401) {
        // Refresh token or logout
      }
      return handler.next(error);
    },
  ),
);
```

### Pagination

```dart
class PostsProvider extends ChangeNotifier {
  final WordPressService _wordpressService;
  List<WordPressPost> _posts = [];
  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> loadMorePosts() async {
    if (!_hasMore) return;

    final newPosts = await _wordpressService.getPosts(
      page: _currentPage,
    );

    if (newPosts.isEmpty) {
      _hasMore = false;
    } else {
      _posts.addAll(newPosts);
      _currentPage++;
    }

    notifyListeners();
  }
}
```

## Need Help?

- Check the [README](README.md) for more information
- See [DEVELOPMENT.md](DEVELOPMENT.md) for development guidelines
- Open an issue on GitHub for specific problems
