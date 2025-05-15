// 📁 lib/services/permission_service.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // التحقق من صلاحية الإذن
  static Future<bool> checkAccess() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // طلب إذن الموقع
  static Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }

  // يمكن إضافة المزيد من الصلاحيات هنا
  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
}