import 'package:hive/hive.dart';

class CartService {
  static const String _boxName = 'cartBox';
  static Box? _box;

  static Future<Box> get _instance async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
    return _box!;
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final box = await _instance;
    return box.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<bool> isInCart(String productId) async {
    final box = await _instance;
    return box.containsKey(productId);
  }

  static Future<void> addToCart(Map<String, dynamic> product) async {
    final box = await _instance;
    final existingItem = await box.get(product['id']);

    if (existingItem != null) {
      await box.put(product['id'], {
        ...existingItem,
        'qty': (existingItem['qty'] ?? 1) + 1,
      });
    } else {
      await box.put(product['id'], {
        'id': product['id'],
        'title': product['title'],
        'imageUrl': product['imageUrl'] ?? product['image'],
        'price': product['price'] ?? product['productPrice'],
        'salePrice': product['salePrice'],
        'qty': 1,
      });
    }
  }

  static Future<void> removeFromCart(String productId) async {
    final box = await _instance;
    await box.delete(productId);
  }

  static Future<void> updateQuantity(String productId, int newQuantity) async {
    final box = await _instance;
    final item = await box.get(productId);

    if (item != null) {
      if (newQuantity > 0) {
        await box.put(productId, {
          ...item,
          'qty': newQuantity,
        });
      } else {
        await removeFromCart(productId);
      }
    }
  }

  static Future<void> clearCart() async {
    final box = await _instance;
    await box.clear();
  }

  static Future<double> getTotal() async {
    final items = await getCartItems();
    double sum = 0;

    for (var item in items) {
      final price = item['salePrice'] ?? item['price'] ?? item['productPrice'];
      final quantity = item['qty'] ?? 1;
      sum += (price as num).toDouble() * quantity;
    }

    return sum;
  }
}