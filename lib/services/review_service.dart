import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';

class ReviewService {
  static const String baseUrl = "https://www.etjer.store/api/reviews"; // غيّر العنوان حسب مشروعك
  static Future<List<Review>> getReviews({
    required String storeId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        'storeId': storeId,
        'page': page.toString(),
        'limit': limit.toString(),
        'include': 'customerStore.customer', // تضمين البيانات المرتبطة
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return data.map((e) => Review.fromJson(e)).toList();
      }
      throw Exception('فشل في التحميل: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ في جلب البيانات: ${e.toString()}');
    }
  }




  // static Future<List<Review>> getReviews(String storeId) async {
  //   try {
  //     final uri = Uri.parse('$baseUrl?storeId=$storeId');
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // 'Accept': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
  //       return data.map((e) => Review.fromJson(e)).toList();
  //     } else {
  //       throw Exception("فشل في جلب التقييمات: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("خطأ في getReviews: $e");
  //     rethrow;
  //   }
  // }
  static Future<bool> createReview(int rating, String comment,
      {String? storeId, String? customerStoreId}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'storeId': storeId,
          'customerStoreId': customerStoreId,
          'rating': rating,
          'comment': comment,
        }),
      );

      print("الاستجابة: ${response.statusCode}");
      print("النص: ${response.body}");

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 409) {
        // تقييم مكرر
        throw Exception("لقد قمت بتقييم هذا المتجر من قبل.");
      } else {
        throw Exception("فشل التقييم: ${response.body}");
      }
    } catch (e) {
      print("خطأ في إرسال التقييم: $e");
      rethrow;
    }
  }


  static Future<bool> updateReview(String reviewId, int rating, String comment) async {
    final response = await http.patch(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'reviewId': reviewId,
        'rating': rating,
        'comment': comment,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteReview(String reviewId) async {
    final uri = Uri.parse("$baseUrl?reviewId=$reviewId");
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}
