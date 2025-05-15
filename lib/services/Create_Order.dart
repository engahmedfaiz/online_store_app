import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/Order.dart';

Future<void> createOrder(Order order) async {
  final response = await http.post(
    Uri.parse('https://www.etjer.store/api/orders'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(order),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to create order');
  }
}
