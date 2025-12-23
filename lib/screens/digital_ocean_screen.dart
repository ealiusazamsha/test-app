import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class DigitalOceanScreen extends StatefulWidget {
  const DigitalOceanScreen({super.key});

  @override
  State<DigitalOceanScreen> createState() => _DigitalOceanScreenState();
}

class _DigitalOceanScreenState extends State<DigitalOceanScreen> {
  bool _isLoading = false;
  List<dynamic> _droplets = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDroplets();
  }

  Future<void> _loadDroplets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      if (authService.accessToken != null) {
        apiService.setAuthToken(authService.accessToken!);
      }
      
      final droplets = await apiService.getDroplets();
      
      if (mounted) {
        setState(() {
          _droplets = droplets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load droplets. Configure Digital Ocean API in .env';
          _isLoading = false;
          _droplets = _getDemoDroplets();
        });
      }
    }
  }

  List<dynamic> _getDemoDroplets() {
    return [
      {
        'name': 'demo-server-1',
        'region': {'name': 'New York 3'},
        'size': {'slug': 's-1vcpu-1gb'},
        'status': 'active',
        'ip_address': '192.0.2.1',
      },
      {
        'name': 'demo-server-2',
        'region': {'name': 'San Francisco 2'},
        'size': {'slug': 's-2vcpu-2gb'},
        'status': 'active',
        'ip_address': '192.0.2.2',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Ocean'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  Icon(Icons.info_outline, 
                    color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _droplets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off, 
                              size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No droplets found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _loadDroplets,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDroplets,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _droplets.length,
                          itemBuilder: (context, index) {
                            final droplet = _droplets[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: 
                                    droplet['status'] == 'active'
                                        ? Colors.green
                                        : Colors.grey,
                                  child: const Icon(
                                    Icons.cloud,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  droplet['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('Region: ${droplet['region']?['name'] ?? 'N/A'}'),
                                    Text('Size: ${droplet['size']?['slug'] ?? 'N/A'}'),
                                    if (droplet['ip_address'] != null)
                                      Text('IP: ${droplet['ip_address']}'),
                                  ],
                                ),
                                trailing: Chip(
                                  label: Text(
                                    droplet['status'] ?? 'unknown',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: 
                                    droplet['status'] == 'active'
                                        ? Colors.green.shade100
                                        : Colors.grey.shade200,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create droplet functionality coming soon'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Droplet'),
      ),
    );
  }
}
