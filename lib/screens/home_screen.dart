import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/wordpress_service.dart';
import '../services/api_service.dart';
import '../models/wordpress_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<WordPressPost> _posts = [];
  bool _isLoadingPosts = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoadingPosts = true;
    });

    final wordpressService = Provider.of<WordPressService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      final posts = await wordpressService.getPosts(
        authToken: authService.accessToken,
      );

      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading posts: $e');
      // Load demo posts if real posts fail
      if (mounted) {
        setState(() {
          _posts = _getDemoPosts();
          _isLoadingPosts = false;
        });
      }
    }
  }

  List<WordPressPost> _getDemoPosts() {
    return [
      WordPressPost(
        id: 1,
        title: 'Welcome to Test App',
        content: '<p>This is a demo post. Configure WordPress to see real posts.</p>',
        excerpt: 'Demo post showing app functionality',
        date: DateTime.now().toIso8601String(),
        status: 'publish',
        link: 'https://demo.com/post-1',
        authorId: 1,
      ),
      WordPressPost(
        id: 2,
        title: 'Getting Started Guide',
        content: '<p>Learn how to use the app features.</p>',
        excerpt: 'Quick start guide for new users',
        date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        status: 'publish',
        link: 'https://demo.com/post-2',
        authorId: 1,
      ),
      WordPressPost(
        id: 3,
        title: 'Configure Your Backend',
        content: '<p>Set up Keycloak and WordPress integration.</p>',
        excerpt: 'Setup instructions for backend services',
        date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        status: 'publish',
        link: 'https://demo.com/post-3',
        authorId: 1,
      ),
    ];
  }

  Future<void> _handleLogout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildPostsTab() {
    if (_isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No posts available'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPosts,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Show demo mode banner if using demo posts
        Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.isDemoMode || _posts.first.id <= 3) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, 
                      color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Showing demo posts. Configure WordPress URL in .env for real content',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadPosts,
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to post detail
                      _showPostDetail(context, post);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPostDetail(BuildContext context, WordPressPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(post.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Published: ${post.date}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                post.excerpt,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildServiceCard(
              'Digital Ocean',
              'Manage your droplets and infrastructure',
              Icons.cloud_outlined,
              Colors.blue,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Digital Ocean service')),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              'API Services',
              'Connect to external APIs and services',
              Icons.api_outlined,
              Colors.green,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Services')),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              'WordPress',
              'Manage your WordPress content',
              Icons.wordpress_outlined,
              Colors.orange,
              () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final userInfo = authService.userInfo;
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Demo mode indicator
            if (authService.isDemoMode)
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Demo Mode Active - Configure .env for real backend',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (authService.isDemoMode) const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        userInfo?['preferred_username']?[0].toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 36, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userInfo?['preferred_username'] ?? 'User',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userInfo?['email'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    if (authService.isDemoMode) ...[
                      const SizedBox(height: 8),
                      Chip(
                        label: const Text('Demo User'),
                        backgroundColor: Colors.amber.shade100,
                        labelStyle: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile settings')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App settings')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App version 1.0.0')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildPostsTab(),
      _buildServicesTab(),
      _buildProfileTab(),
    ];

    final titles = ['Posts', 'Services', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        elevation: 2,
        actions: [
          Consumer<AuthService>(
            builder: (context, authService, _) {
              if (authService.isDemoMode) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: const Text('DEMO', style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.amber.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
