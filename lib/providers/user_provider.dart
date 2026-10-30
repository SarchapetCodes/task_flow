import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const String _nameKey = 'user_name';

  String _name = 'Արեն';

  String get name => _name;

  UserProvider() {
    _loadName();
  }

  Future<void> _loadName() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _name = prefs.getString(_nameKey) ?? 'Արեն';

      notifyListeners();
    } catch (e) {
      debugPrint('Անունը բեռնելու սխալ՝ $e');
    }
  }

  Future<void> updateName(String newName) async {
    final trimmedName = newName.trim();

    if (trimmedName.isEmpty || trimmedName == _name) {
      return;
    }

    _name = trimmedName;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, _name);
    } catch (e) {
      debugPrint('Անունը պահպանելու սխալ՝ $e');
    }
  }
}
