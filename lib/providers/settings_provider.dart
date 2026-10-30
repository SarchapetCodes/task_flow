import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _reminderKey = 'reminders_enabled';

  bool _remindersEnabled = true;

  bool get remindersEnabled => _remindersEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _remindersEnabled = prefs.getBool(_reminderKey) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Կարգավորումները բեռնելու սխալ՝ $e');
    }
  }

  Future<void> setRemindersEnabled(bool value) async {
    if (_remindersEnabled == value) return;

    _remindersEnabled = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reminderKey, value);
    } catch (e) {
      debugPrint('Կարգավորումները պահպանելու սխալ՝ $e');
    }
  }
}
