// 📁 services/PaymentService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/PaymentProvider.dart';

class PaymentService {
  static const String baseUrl = "https://www.etjer.store/api";

  /// جلب طرق الدفع المفعّلة للمتجر
  static Future<List<PaymentProvider>> getPaymentMethods(String storeId) async {
    final url = Uri.parse("$baseUrl/storePaymentSetting?storeId=$storeId");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("فشل في تحميل طرق الدفع: ${response.statusCode}");
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) {
      throw Exception("البيانات غير صالحة من السيرفر");
    }

    return decoded.map<PaymentProvider>((item) {
      final p = item['paymentProvider'] as Map<String, dynamic>? ?? {};
      return PaymentProvider(
        id: p['id']          as String? ?? '',
        name: p['name']      as String? ?? '—',

        imageUrl: p['imageUrl'] as String? ?? '',
        isActive: p['isActive'] as bool? ?? false,
      );
    }).toList();
  }
}
