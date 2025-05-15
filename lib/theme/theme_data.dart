// import 'package:flutter/material.dart';
// import 'package:shop/services/api_service.dart';
// import 'package:hive/hive.dart';
//
// import '../models/Customization_Model.dart';
//
// class ThemeProvider with ChangeNotifier {
//   ThemeColorsModel? _customization;
//   MaterialColor? _primaryMaterialColor;
//
//   bool _isDarkMode = false;  // إضافة متغير لتخزين حالة الوضع
//   bool get isDarkMode => _isDarkMode;  // الدالة للحصول على الحالة الحالية للوضع
//
//   ThemeColorsModel? get customization => _customization;
//
//   Color get primaryColor => _customization != null
//       ? _customization!.hexToColor(_customization!.primaryColor)
//       : const Color(0xFF6200EE);
//
//   Color get secondaryColor => _customization != null
//       ? _customization!.hexToColor(_customization!.secondaryColor)
//       : const Color(0xFF03DAC6);
//
//   Color get backgroundColor => _customization != null
//       ? _customization!.hexToColor(_customization!.backgroundColor)
//       : Colors.white;
//
//   Color get textColor => _customization != null
//       ? _customization!.hexToColor(_customization!.primaryColor)
//       : Colors.black;
//
//   MaterialColor get primaryMaterialColor {
//     if (_primaryMaterialColor != null) return _primaryMaterialColor!;
//     if (_customization == null) return Colors.blue;
//
//     _primaryMaterialColor = MaterialColor(
//       primaryColor.value,
//       <int, Color>{
//         50: primaryColor.withOpacity(0.1),
//         100: primaryColor.withOpacity(0.2),
//         200: primaryColor.withOpacity(0.3),
//         300: primaryColor.withOpacity(0.4),
//         400: primaryColor.withOpacity(0.5),
//         500: primaryColor.withOpacity(0.6),
//         600: primaryColor.withOpacity(0.7),
//         700: primaryColor.withOpacity(0.8),
//         800: primaryColor.withOpacity(0.9),
//         900: primaryColor.withOpacity(1.0),
//       },
//     );
//     return _primaryMaterialColor!;
//   }
//
//   // تحميل التخصيصات من الـ API بالإضافة إلى تحميل إعدادات الوضع
//   Future<void> loadCustomization(String storeId) async {
//     final data = await ApiService.fetchStoreCustomizations(storeId: storeId);
//     if (data != null && data['isActive'] == true) {
//       _customization = ThemeColorsModel.fromJson(data);
//       _primaryMaterialColor = null; // Reset to regenerate
//       await _loadThemeMode();  // تحميل وضع السمة من التخزين
//       notifyListeners();
//     }
//   }
//
//   // دالة لتبديل وضع السمة (الليلي/النهاري)
//   void toggleTheme() {
//     _isDarkMode = !_isDarkMode;
//     _saveThemeMode();  // حفظ التغيير في التخزين
//     notifyListeners();
//   }
//
//   // تحميل حالة السمة (ليلي أو نهاري) من التخزين (Hive)
//   Future<void> _loadThemeMode() async {
//     var box = await Hive.openBox('settings');
//     _isDarkMode = box.get('isDarkMode', defaultValue: false);
//   }
//
//   // حفظ حالة السمة (ليلي أو نهاري) في التخزين (Hive)
//   Future<void> _saveThemeMode() async {
//     var box = await Hive.openBox('settings');
//     box.put('isDarkMode', _isDarkMode);
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop/models/customization_model.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ThemeProvider extends ChangeNotifier {
  late bool _isDarkMode;
  late Color primaryColor;
  late Color secondaryColor;
  late Color backgroundColor;
  late Color textColor;
  late MaterialColor primaryMaterialColor;
  ThemeColorsModel? customization;

  ThemeProvider() {
    _isDarkMode = false;
    primaryColor = Colors.blue;
    secondaryColor = Colors.amber;
    backgroundColor = Colors.white;
    textColor = Colors.black;
    primaryMaterialColor = Colors.blue;
    loadThemeMode(); // تحميل الوضع من Hive عند الإنشاء
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await Hive.box('settingsBox').put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final box = Hive.box('settingsBox');
    _isDarkMode = box.get('isDarkMode', defaultValue: false);
    notifyListeners();
  }

  Future<void> loadCustomization(String storeId) async {
    final result = await ApiService.fetchStoreCustomizations(storeId: storeId);
    if (result != null) {
      // نتيجة result هي Map<String, dynamic>
      // استخراج الحقول مع قيم افتراضية في حال عدم وجودها
      final primaryHex    = result['primaryColor']    as String? ?? '#6200EE';
      final secondaryHex  = result['secondaryColor']  as String? ?? '#03DAC6';
      final backgroundHex = result['backgroundColor'] as String? ?? '#FFFFFF';
      final accentHex     = result['accentColor']     as String? ?? '#FF4081';

      primaryColor         = HexColor.fromHex(primaryHex);
      secondaryColor       = HexColor.fromHex(secondaryHex);
      backgroundColor      = HexColor.fromHex(backgroundHex);
      textColor            = HexColor.fromHex(accentHex);
      primaryMaterialColor = createMaterialColor(primaryColor);

      notifyListeners();
    } else {
      print('فشل في تحميل التخصيص');
    }
  }
  MaterialColor createMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color.withOpacity(.1),
      100: color.withOpacity(.2),
      200: color.withOpacity(.3),
      300: color.withOpacity(.4),
      400: color.withOpacity(.5),
      500: color.withOpacity(.6),
      600: color.withOpacity(.7),
      700: color.withOpacity(.8),
      800: color.withOpacity(.9),
      900: color.withOpacity(1),
    });
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    final formatted = hexColor.toUpperCase().replaceAll("#", "");
    return int.parse("FF$formatted", radix: 16);
  }

  HexColor.fromHex(String hexColor) : super(_getColorFromHex(hexColor));
}
