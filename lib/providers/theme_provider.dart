import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isDarkMode = prefs.getBool(_themeKey) ?? false;

      notifyListeners();
    } catch (e) {
      debugPrint('Թեման բեռնելու սխալ՝ $e');
    }
  }

  Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Թեման պահպանելու սխալ՝ $e');
    }
  }
}
