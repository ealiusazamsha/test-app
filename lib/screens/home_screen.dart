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
    
    final posts = await wordpressService.getPosts(
      authToken: authService.accessToken,
    );

    setState(() {
      _posts = posts;
      _isLoadingPosts = false;
    });
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

    return RefreshIndicator(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post: ${post.title}')),
                );
              },
            ),
          );
        },
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test App'),
        elevation: 2,
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
