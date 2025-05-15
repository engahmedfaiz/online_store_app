import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// صور تجريبية
const productDemoImg1 = "https://i.imgur.com/CGCyp1d.png";
const productDemoImg2 = "https://i.imgur.com/AkzWQuJ.png";
const productDemoImg3 = "https://i.imgur.com/J7mGZ12.png";
const productDemoImg4 = "https://i.imgur.com/q9oF9Yq.png";
const productDemoImg5 = "https://i.imgur.com/MsppAcx.png";
const productDemoImg6 = "https://i.imgur.com/JfyZlnO.png";

// الخط الافتراضي
const String grandisExtendedFont = "Grandis Extended";

// الألوان الرئيسية
const Color primaryColor = Color(0xFF7B61FF);
const MaterialColor primaryMaterialColor = MaterialColor(0xFF9581FF, <int, Color>{
  50: Color(0xFFEFECFF),
  100: Color(0xFFD7D0FF),
  200: Color(0xFFBDB0FF),
  300: Color(0xFFA390FF),
  400: Color(0xFF8F79FF),
  500: Color(0xFF7B61FF),
  600: Color(0xFF7359FF),
  700: Color(0xFF684FFF),
  800: Color(0xFF5E45FF),
  900: Color(0xFF6C56DD),
});

// ألوان الأسود بدرجات
const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

// ألوان الأبيض بدرجات
const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

// ألوان إضافية
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kBackgroundColor = Color(0xFFF9F8FD);
const kTextColor = Color(0xFF3C4046);
const kTextLightColor = Color(0xFF7280A4);
const kSecondaryColor = Color(0xFF979797);
const kProcessingColor = Color(0xFFFFA726);
const kShippedColor = Color(0xFF42A5F5);
const kDeliveredColor = Color(0xFF66BB6A);
const kCanceledColor = Color(0xFFEF5350);
const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

// الهوامش والحواف والزمن الافتراضي
const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

// أنماط النصوص
const TextStyle sectionHeaderStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

// الهوامش
const EdgeInsets sectionPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding / 2,
);

// التحقق من صحة الحقول
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

const pasNotMatchErrorText = "passwords do not match";

// ثوابت عامة
class Constants {
  static const String grandisExtendedFont = 'GrandisExtended';
  static const double defaultPadding = 16.0;
  static const String defaultBannerImage = 'https://i.imgur.com/K41Mj7C.png';
}

class GlobalColors {
  static const Color mainColor = Color(0xFF2A4BA0);
}
