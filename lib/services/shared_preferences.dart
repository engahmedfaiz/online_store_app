import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _favoritesBox = 'favorites';

  static Box<String>? _box;

  static Future<Box<String>> _getBox() async {
    _box ??= await Hive.openBox<String>(_favoritesBox);
    return _box!;
  }
  static Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesBox);

    // أو إذا كنت تستخدم Hive:
    final box = await _getBox();
    await box.clear();
  }
  static Future<void> addToFavorites(String productId) async {
    final box = await _getBox();
    await box.put(productId, productId);
  }

  static Future<void> removeFromFavorites(String productId) async {
    final box = await _getBox();
    await box.delete(productId);
  }

  static Future<bool> isFavorite(String productId) async {
    final box = await _getBox();
    return box.containsKey(productId);
  }

  static Future<List<String>> getFavorites() async {
    final box = await _getBox();
    return box.values.toList();
  }
}