import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeService() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey);
      
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
