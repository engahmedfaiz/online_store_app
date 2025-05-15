import 'package:hive/hive.dart';

class SettingsService {
  static const String _boxName = 'settingsBox';
  static Box? _box;

  static Future<Box> get _instance async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
    return _box!;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final box = await _instance;
    await box.put('darkMode', isDark);
  }

  static Future<bool> isDarkMode() async {
    final box = await _instance;
    return box.get('darkMode', defaultValue: false);
  }

  static Future<void> clearSettings() async {
    final box = await _instance;
    await box.clear();
  }
}