import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/category_model.dart';

const String apiUrl = "https://www.etjer.store";
class ApiService {
  static String? _storeId;

  static void initialize(String storeId) {
    _storeId = storeId;
  }

  static Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (_storeId == null) throw Exception('Store ID not initialized');

    try {
      final allProducts = await getProducts(_storeId!);
      return allProducts.where((product) => ids.contains(product.id)).toList();
    } catch (e) {
      throw Exception('Failed to load favorite products: $e');
    }
  }
  static Future<List<ProductModel>> getCategoryProducts({
    required String storeId,
    required String? categoryId,
  }) async {
    try {
      if (categoryId == null) {
        throw Exception("معرف القسم (categoryId) مطلوب");
      }

      final Uri uri = Uri.parse(
        '$apiUrl/api/products?storeId=$storeId&categoryId=$categoryId',
      );

      print('Requesting products from: $uri'); // للتتبع

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = json.decode(decodedBody);
        return jsonData.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception("فشل في جلب منتجات القسم: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء جلب منتجات القسم: ${e.toString()}");
    }
  }























  static Future<List<ProductModel>> getProducts(String storeId, {String? categoryId}) async {
    try {
      final uri = Uri.parse('$apiUrl/api/products').replace(
        queryParameters: {
          'storeId': storeId,
          if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
        },
      );

      debugPrint('Fetching products from: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {'Accept-Language': 'ar'},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = json.decode(decodedBody);
        return jsonData.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Product fetch error: $e");
      throw Exception("Connection error: ${e.toString()}");
    }
  }

  static Future<List<CategoryModel>> getCategories(String storeId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/categories?storeId=$storeId'),
        headers: {'Accept-Language': 'ar'},
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return (json.decode(decodedBody) as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Category fetch error: $e");
      throw Exception("Connection error: ${e.toString()}");
    }
  }
}