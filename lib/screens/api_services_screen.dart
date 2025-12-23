import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ApiServicesScreen extends StatefulWidget {
  const ApiServicesScreen({super.key});

  @override
  State<ApiServicesScreen> createState() => _ApiServicesScreenState();
}

class _ApiServicesScreenState extends State<ApiServicesScreen> {
  final _urlController = TextEditingController();
  final _endpointController = TextEditingController();
  String _selectedMethod = 'GET';
  String? _response;
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  Future<void> _callApi() async {
    if (_urlController.text.isEmpty || _endpointController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _response = null;
    });

    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.accessToken != null) {
      apiService.setAuthToken(authService.accessToken!);
    }

    try {
      final response = await apiService.callExternalService(
        _urlController.text,
        _endpointController.text,
        method: _selectedMethod,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _response = response != null 
            ? 'Status: ${response.statusCode}\n\nResponse:\n${response.data}'
            : 'No response received';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Test API endpoints from external services',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick access cards
            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAccessCard(
                    'JSONPlaceholder',
                    'Test REST API',
                    Icons.api,
                    Colors.green,
                    () {
                      _urlController.text = 'https://jsonplaceholder.typicode.com';
                      _endpointController.text = '/posts/1';
                      _selectedMethod = 'GET';
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAccessCard(
                    'GitHub API',
                    'Public API',
                    Icons.code,
                    Colors.purple,
                    () {
                      _urlController.text = 'https://api.github.com';
                      _endpointController.text = '/repos/flutter/flutter';
                      _selectedMethod = 'GET';
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // API Configuration
            const Text(
              'API Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Base URL
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Base URL',
                hintText: 'https://api.example.com',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Endpoint
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'Endpoint',
                hintText: '/api/v1/users',
                prefixIcon: Icon(Icons.route),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // HTTP Method
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              decoration: const InputDecoration(
                labelText: 'HTTP Method',
                prefixIcon: Icon(Icons.http),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'GET', child: Text('GET')),
                DropdownMenuItem(value: 'POST', child: Text('POST')),
                DropdownMenuItem(value: 'PUT', child: Text('PUT')),
                DropdownMenuItem(value: 'DELETE', child: Text('DELETE')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMethod = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Call API button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _callApi,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Call API'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Response section
            if (_response != null) ...[
              const Text(
                'Response',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _response!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
