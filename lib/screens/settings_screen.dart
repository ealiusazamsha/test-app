import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Consumer<AuthService>(
            builder: (context, authService, _) {
              if (authService.isDemoMode) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, 
                            color: Colors.amber.shade700),
                          const SizedBox(width: 12),
                          Text(
                            'Demo Mode Active',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You are using the app in demo mode. To connect to real backend services:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. Create a .env file in the project root\n'
                        '2. Configure your Keycloak server details\n'
                        '3. Add WordPress URL (optional)\n'
                        '4. Add Digital Ocean API key (optional)\n'
                        '5. Rebuild and restart the app',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Account',
            [
              _buildListTile(
                context,
                Icons.person_outline,
                'Profile',
                'Manage your profile information',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile settings')),
                  );
                },
              ),
              _buildListTile(
                context,
                Icons.security_outlined,
                'Security',
                'Password and authentication',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security settings')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'Preferences',
            [
              Consumer<ThemeService>(
                builder: (context, themeService, _) {
                  return ListTile(
                    leading: Icon(
                      themeService.isDarkMode 
                          ? Icons.dark_mode 
                          : Icons.light_mode,
                    ),
                    title: const Text('Theme'),
                    subtitle: Text(
                      themeService.isDarkMode 
                          ? 'Dark Mode' 
                          : themeService.isLightMode 
                              ? 'Light Mode' 
                              : 'System Default',
                    ),
                    trailing: Switch(
                      value: themeService.isDarkMode,
                      onChanged: (value) {
                        themeService.setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                    onTap: () {
                      _showThemeDialog(context);
                    },
                  );
                },
              ),
              _buildListTile(
                context,
                Icons.notifications_outlined,
                'Notifications',
                'Manage notification preferences',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification settings')),
                  );
                },
              ),
              _buildListTile(
                context,
                Icons.language_outlined,
                'Language',
                'Select your preferred language',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language settings')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            'About',
            [
              _buildListTile(
                context,
                Icons.info_outlined,
                'App Version',
                '1.0.0',
                null,
              ),
              _buildListTile(
                context,
                Icons.description_outlined,
                'Terms of Service',
                'Read our terms',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terms of Service')),
                  );
                },
              ),
              _buildListTile(
                context,
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                'Read our privacy policy',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: onTap,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return AlertDialog(
            title: const Text('Choose Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: themeService.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      themeService.setThemeMode(mode);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: themeService.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      themeService.setThemeMode(mode);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeService.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      themeService.setThemeMode(mode);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
