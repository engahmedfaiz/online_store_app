// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // const String BASE_URL = "https://www.etjer.store"; // تأكد من https
// //
// // class ApiService {
// //   static Future<List<dynamic>> getBanners(String storeId) async {
// //     final response = await http.get(
// //       Uri.parse('$BASE_URL/api/banners?storeId=$storeId'),
// //       headers: {'Content-Type': 'application/json'},
// //     );
// //
// //     if (response.statusCode == 200) {
// //       return json.decode(response.body);
// //     } else {
// //       throw Exception("فشل في جلب البانرات");
// //     }
// //   }
// //
// // // أضف المزيد لاحقًا: getProducts, getCategories...
// // }
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/category_model.dart';
// import '../models/banner_model.dart';
//
// class ApiService {
//   static const String apiUrl = "https://www.etjer.store";
//
//   static Future<List<BannerModel>> getBanners(String storeId) async {
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/banners?storeId=$storeId'),
//     );
//
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((json) => BannerModel.fromJson(json))
//           .toList();
//     }
//     throw Exception('Failed to load banners');
//   }
//
//   static Future<List<CategoryModel>> getCategories(String storeId) async {
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/categories?storeId=$storeId'),
//     );
//
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((json) => CategoryModel.fromJson(json))
//           .toList();
//     }
//     throw Exception('Failed to load categories');
//   }
// }
// import 'package:http/http.dart' as http;
// import 'package:shop/models/product_model.dart';
// import 'dart:convert';
// import '../models/category_model.dart';
// import '../models/banner_model.dart';
// import '../models/sub_category_model.dart'; // تأكد من استيراد النموذج
//  const String apiUrl = "https://www.etjer.store";
//
// class ApiService {
//   static const String apiUrl = "https://www.etjer.store";
//
//   // دوال البانرات
//   static Future<List<BannerModel>> getBanners(String storeId) async {
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/banners?storeId=$storeId'),
//     );
//
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((json) => BannerModel.fromJson(json))
//           .toList();
//     }
//     throw Exception('Failed to load banners');
//   }
//
//   // دوال الفئات الرئيسية
//   static Future<List<CategoryModel>> getCategories(String storeId) async {
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/categories?storeId=$storeId'),
//     );
//
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((json) => CategoryModel.fromJson(json))
//           .toList();
//     }
//     throw Exception('Failed to load categories');
//   }
//
//   // دوال الفئات الفرعية (الإضافة الجديدة)
//   static Future<List<SubCategoryModel>> getSubCategories({
//     required String storeId,
//     String? categoryId,
//   }) async {
//     final queryParams = {
//       'storeId': storeId,
//       if (categoryId != null) 'categoryId': categoryId,
//     };
//
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/subcategory').replace(queryParameters: queryParams),
//     );
//
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((json) => SubCategoryModel.fromJson(json))
//           .toList();
//     }
//     throw Exception('Failed to load subcategories');
//   }
//   static Future<List<ProductModel>> getProducts(String storeId) async {
//
//     final response = await http.get(
//       Uri.parse('$apiUrl/api/products?storeId=$storeId'),
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map((item) => ProductModel.fromJson(item)).toList();
//     } else {
//       throw Exception("فشل في جلب المنتجات");
//     }
//   }
// // يمكن إضافة المزيد من الدوال هنا...
// }
import 'package:http/http.dart' as http;
import 'package:shop/models/StoreModel.dart';
import 'package:shop/models/product_model.dart';
import 'dart:convert';
import '../models/Customization_Model.dart';
import '../models/category_model.dart';
import '../models/banner_model.dart';
import '../models/sub_category_model.dart';

const String apiUrl = "https://www.etjer.store";

class ApiService {
  // ✅ دوال البانرات
  static Future<List<BannerModel>> getBanners(String storeId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/banners?storeId=$storeId'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return (json.decode(decodedBody) as List)
          .map((json) => BannerModel.fromJson(json))
          .toList();
    }
    throw Exception('فشل في جلب البانرات');
  }

  // ✅ دوال الفئات الرئيسية
  static Future<List<CategoryModel>> getCategories(String storeId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/categories?storeId=$storeId'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return (json.decode(decodedBody) as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }
    throw Exception('فشل في جلب الفئات');
  }

  // ✅ دوال الفئات الفرعية
  // static Future<List<SubCategoryModel>> getSubCategories({
  //   required String storeId,
  //   String? categoryId,
  // }) async {
  //   final queryParams = {
  //     'storeId': storeId,
  //     if (categoryId != null) 'categoryId': categoryId,
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse('$apiUrl/api/subcategory').replace(queryParameters: queryParams),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final decodedBody = utf8.decode(response.bodyBytes);
  //     return (json.decode(decodedBody) as List)
  //         .map((json) => SubCategoryModel.fromJson(json))
  //         .toList();
  //   }
  //   throw Exception('فشل في جلب الفئات الفرعية');
  // }








  static Future<List<ProductModel>> getProducts(String storeId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/products?storeId=$storeId'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodedBody);
      return jsonData.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception("فشل في جلب المنتجات");
    }
  }

  static Future<List<ProductModel>> getPrxoducts({
    required String subcategoryId,
    required String categoryId,
  }) async {
    final response = await http.get(
      Uri.parse('$apiUrl/products?subcategoryId=$subcategoryId&categoryId=$categoryId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': 'ar', // إضافة header للغة العربية
      },
    );

    if (response.statusCode == 200) {
      final List productsJson = json.decode(utf8.decode(response.bodyBytes)); // استخدام utf8.decode للتعامل مع النصوص العربية
      return productsJson
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList();
    } else {
      throw Exception('فشل في تحميل المنتجات'); // رسالة الخطأ بالعربية
    }
  }
  static Future<Map<String, dynamic>> placeOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/orders'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'order': responseData,
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'فشل إرسال الطلب',
      };
    }
  }

  static Future<List<dynamic>> getOrders({
    required String token,
    String? storeId,
    String? userId,
  }) async {
    final queryParams = {
      if (storeId != null) 'storeId': storeId,
      if (userId != null) 'userId': userId,
    };

    final response = await http.get(
      Uri.parse('$apiUrl/api/orders').replace(queryParameters: queryParams),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل جلب الطلبات');
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required String token,
    required String orderId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/api/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': orderId,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل تحديث حالة الطلب');
    }
  }
  static Future<List<SubCategoryModel>> getSubCategories({
    required String storeId,
    required String categoryId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/subcategory')
            .replace(queryParameters: {
          'storeId': storeId,
          'categoryId': categoryId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return data.map((e) => SubCategoryModel.fromJson(e)).toList();
      }
      throw Exception('فشل التحميل: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }




  static Future<Store?> fetchStore({required String storeId}) async {
    try {
      // التحقق من أن معرف المتجر غير فارغ
      if (storeId.isEmpty) {
        print("storeId فارغ");
        return null;
      }

      // إرسال الطلب إلى API
      final response = await http.get(
        Uri.parse("$apiUrl/api/stores?storeId=$storeId"),
      );

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        // استخدام utf8.decode لتحويل الاستجابة إلى نص صحيح
        String responseBody = utf8.decode(response.bodyBytes);

        // طباعة الاستجابة لمراجعتها
        print("الاستجابة: $responseBody");

        // محاولة فك ترميز الـ JSON
        final List data = json.decode(responseBody);

        // التحقق من أن البيانات غير فارغة
        if (data.isNotEmpty) {
          // إعادة الكائن Store باستخدام البيانات المستلمة
          return Store.fromJson(data[0]);
        } else {
          print("لا يوجد متجر بهذا المعرف");
          return null;
        }
      } else {
        // طباعة رسالة خطأ في حال كانت حالة الاستجابة غير 200
        print("خطأ في جلب المتجر - كود الحالة: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // التعامل مع الاستثناءات وطباعة الأخطاء
      print("استثناء أثناء جلب المتجر: $e");
      return null;
    }
  }
// في ملف ApiService أضف هذا:
    static Future<Map<String, dynamic>?> fetchStoreCustomizations({required String storeId}) async {
      try {
        final response = await http.get(
          Uri.parse('$apiUrl/api/customizations?storeId=$storeId'),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data is List && data.isNotEmpty) {
            return Map<String, dynamic>.from(data[0]); // نأخذ العنصر الأول من القائمة
          }
        }
        return null;
      } catch (e) {
        print("Error fetching customizations: $e");
        return null;
      }
    }
  // static Future<ThemeColorsModel?> getStoreCustomization(String storeId, {required String storeId}) async {
  //   final url =Uri.parse('$apiUrl/api/customizations?storeId=$storeId');
  //
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return ThemeColorsModel.fromJson(data['data']);
  //     } else {
  //       print('خطأ في جلب التخصيص: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('استثناء أثناء جلب التخصيص: $e');
  //     return null;
  //   }
  // }

}










  // Future<StoreModel?> fetchStoreById(String storeId) async {
  //   final url = Uri.parse('$apiUrl/api/stores?storeId=$storeId');
  //
  //   try {
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       return StoreModel.fromJson(jsonData);
  //     } else {
  //       print('Store not found. Status: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching store: $e');
  //     return null;
  //   }
  // }



// يمكن إضافة المزيد من الدوال لاحقًا...

