// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shop/models/AddressModel.dart';
//
// class AddressService {
//   static Future<List<AddressModel>> fetchAddresses({
//     required String customerId,
//     required String storeId,
//     required String token,
//   }) async {
//     final response = await http.get(
//       Uri.parse('https://www.etjer.store/api/addresses?customerId=$customerId&storeId=$storeId'),
//       // headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) ;
//       return data.map((addressJson) => AddressModel.fromJson(addressJson)).toList();
//     } else {
//       throw Exception('Failed to load addresses');
//     }
//   }
//
//   static Future<void> addAddress({
//     required String customerId,
//     required String storeId,
//     required String token,
//     required Map<String, dynamic> address,
//   }) async {
//     final response = await http.post(
//       Uri.parse('https://www.etjer.store/api/addresses'),
//       // headers: {'Authorization': 'Bearer $token'},
//       body: jsonEncode({
//         'customerId': customerId,
//         'storeId': storeId,
//         'address': address,
//       }),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add address');
//     }
//   }
// }
// جلب العناوين الخاصة بالعميل
// static Future<List<ShippingAddress>> fetchAddresses({
//   required String customerId,
//   required String storeId,
//   required String token,
// }) async {
//   final url = Uri.parse("$baseUrl/addresses?customerId=$customerId");
//   final response = await http.get(url, headers: {
//     'Content-Type': 'application/json',
//   });
//
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return List<ShippingAddress>.from(data.map((e) => ShippingAddress.fromJson(e)));
//   } else {
//     throw Exception('فشل في جلب العناوين');
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ShippingAddress.dart';

class AddressService {
  static const baseUrl = "https://www.etjer.store/api";
// في AddressService.dart
  static Future<bool> deleteAddress({
    required String addressId,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/addresses/$addressId");
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
    });

    return response.statusCode == 200;
  }
  static Future<List<ShippingAddress>> fetchAddresses({
    required String customerId,
    required String storeId,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/addresses?customerId=$customerId");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token', // إضافة هذا السطر
    });

    if (response.statusCode == 200) {
      try {
        final utf8Response = utf8.decode(response.bodyBytes); // حل مشكلة الترميز
        final data = jsonDecode(utf8Response) as List;
        return data.map((e) => ShippingAddress.fromJson(e)).toList();
      } catch (e) {
        throw Exception('فشل في تحويل البيانات: $e');
      }
    } else {
      throw Exception('فشل في جلب العناوين: ${response.statusCode}');
    }
  }
  // إضافة عنوان جديد
  static Future<bool> addAddress({
    required String customerId,
    required String storeId,
    required String token,
    required Map<String, dynamic> address,
  }) async {
    final url = Uri.parse("$baseUrl/addresses");
    final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "customerId": customerId,
        "storeId": storeId,
        ...address,
      }),
    );

    return response.statusCode == 201;  // التأكد من حالة الاستجابة
  }
  static Future<bool> updateAddress({
    required String addressId,
    required String token,
    required Map<String, dynamic> address,
  }) async {
    final url = Uri.parse("$baseUrl/addresses/$addressId");
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(address),
    );

    return response.statusCode == 200;
  }
}