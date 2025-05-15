
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Order.dart';
import 'auth_service.dart';

class OrderService {
  static const String apiUrl = "https://www.etjer.store";

  static Future<List<Order>> getUserOrders() async {
    final customerStoreId = await AuthService.fetchCustomerStoreId();

    if (customerStoreId == null) {
      throw Exception('تعذر العثور على معرف ربط العميل والمتجر');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/api/orders/customer/$customerStoreId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((jsonItem) => Order.fromJson(jsonItem)).toList();
    } else {
      throw Exception('فشل جلب الطلبات');
    }
  }

}
