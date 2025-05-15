import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://www.etjer.store/api/customerAuth";
  static const String tokenKey = "auth_token";
  static const String customerIdKey = "customer_id";
  static const String storeIdKey = "store_id";

  /// تحقق مما إذا كان المستخدم مسجل الدخول فعلاً
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    if (token == null) return false;

    try {
      final payload = decodeJwtPayload(token);
      final expiry = payload['exp'];
      if (expiry != null) {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiry * 1000);
        return DateTime.now().isBefore(expiryDate);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
  static Future<String?> fetchCustomerStoreId() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString(customerIdKey);
    final storeId = prefs.getString(storeIdKey);

    if (customerId == null || storeId == null) {
      print('CustomerId أو StoreId غير متوفر');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse("https://www.etjer.store/api/customerStores/customer?customerId=$customerId&storeId=$storeId"),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data is List && data.isNotEmpty && data[0]['id'] != null) {
          return data[0]['id']; // أول CustomerStore
        } else {
          print("الاستجابة لا تحتوي على CustomerStore صالح");
          return null;
        }
      } else {
        print("فشل في جلب customerStoreId: ${response.body}");
        return null;
      }
    } catch (e) {
      print("حدث خطأ أثناء جلب customerStoreId: $e");
      return null;
    }
  }

  static Future<void> updateUserInfo(Map<String, dynamic> userData) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('لم يتم تسجيل الدخول');

      final response = await http.put(
        Uri.parse('https://www.etjer.store/api/customers/$customerIdKey'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode != 200) {
        throw Exception('فشل في تحديث البيانات: ${response.body}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء التحديث: $e');
    }
  }
  /// جلب التوكن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// حفظ التوكن واستخراج customerId و storeId منه
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);

    try {
      final payload = decodeJwtPayload(token);

      final customerId = payload['customerId'];
      final storeId = payload['storeId'];

      if (customerId != null) {
        await prefs.setString(customerIdKey, customerId);
      }

      if (storeId != null) {
        await prefs.setString(storeIdKey, storeId);
      }
    } catch (e) {
      print("Error decoding token: $e");
    }
  }

  /// إزالة بيانات المستخدم من التخزين
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);

    await prefs.remove(customerIdKey);
    await prefs.remove(storeIdKey);
  }

  /// جلب customerId
  static Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(customerIdKey);
  }

  /// جلب storeId
  static Future<String?> getStoreId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(storeIdKey);
  }

  /// حفظ storeId يدويًا
  static Future<void> saveStoreId(String storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storeIdKey, storeId);
  }

  /// فك تشفير payload من JWT
  static Map<String, dynamic> decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token غير صالح');
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      return json.decode(decoded);
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded);
  }

  /// إرسال البريد للتحقق
  static Future<Map<String, dynamic>> sendEmailForAuth(
      String email, String storeId) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "storeId": storeId}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'خطأ في الخادم: ${response.statusCode}'
        };
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  /// التحقق من الكود المُرسل إلى البريد الإلكتروني
  static Future<Map<String, dynamic>> verifyCode(
      String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verifyCode"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "code": code}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'خطأ في الخادم: ${response.statusCode}'
        };
      }

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseData['success'] == true && responseData.containsKey('token')) {
        // حفظ التوكن وكل البيانات المرتبطة به
        await saveToken(responseData['token']);
      }

      return responseData;
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  /// تعبئة البيانات الإضافية بعد التحقق من البريد
  static Future<Map<String, dynamic>> fillDetails({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'غير مصرح به'};
      }

      final response = await http.post(
        Uri.parse("$baseUrl/fillDetails"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "phone": phone,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'خطأ في الخادم: ${response.statusCode}'
        };
      }

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseData.containsKey('code')) {
        // حفظ البيانات المستلمة (customerId و storeId)
        final customerId = responseData['customerId'];
        final storeId = responseData['storeId'];

        if (customerId != null) {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString(customerIdKey, customerId);
          });
        }

        if (storeId != null) {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString(storeIdKey, storeId);
          });
        }

        return {
          'success': true,
          'message': responseData['message'] ?? 'تم الحفظ بنجاح',
          'code': responseData['code'],
        };
      }

      return {
        'success': false,
        'message': responseData['message'] ?? 'فشل في حفظ البيانات',
      };
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }
}