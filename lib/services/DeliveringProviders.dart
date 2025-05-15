import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/DeliveringProvider.dart';

class ShippingService {
  static const String baseUrl = "https://www.etjer.store/api";

  static Future<List<DeliveringProvider>> getShippingCompanies(String storeId) async {
    final url = Uri.parse("$baseUrl/storeDeliveringSetting?storeId=$storeId");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("فشل في تحميل شركات الشحن: ${response.statusCode}");
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) {
      throw Exception("البيانات غير صالحة من السيرفر");
    }

    return decoded.map<DeliveringProvider>((item) {
      return DeliveringProvider.fromJson(item);
    }).toList();
  }
}
