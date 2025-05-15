// // theme/input_decoration_theme.dart
// import 'package:flutter/material.dart';
// import 'package:shop/theme/theme_data.dart';
//
// import '../constants.dart';
//
// InputDecorationTheme lightInputDecorationTheme(ThemeProvider theme) {
//   return InputDecorationTheme(
//     fillColor: theme.backgroundColor.withOpacity(0.1),
//     filled: true,
//     hintStyle: TextStyle(color: theme.textColor.withOpacity(0.4)),
//     border: outlineInputBorder,
//     enabledBorder: outlineInputBorder,
//     focusedBorder: focusedOutlineInputBorder(theme),
//     errorBorder: errorOutlineInputBorder,
//   );
// }
//
// const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
//   borderSide: BorderSide(color: Colors.transparent),
// );
//
// OutlineInputBorder focusedOutlineInputBorder(ThemeProvider theme) {
//   return OutlineInputBorder(
//     borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
//     borderSide: BorderSide(color: theme.primaryColor),
//   );
// }
//
// const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
//   borderSide: BorderSide(color: errorColor),
// );
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shop/theme/theme_data.dart';
// //
// // import '../constants.dart';
// //
// // const InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
// //   fillColor: lightGreyColor,
// //   filled: true,
// //   hintStyle: TextStyle(color: greyColor),
// //   border: outlineInputBorder,
// //   enabledBorder: outlineInputBorder,
// //   focusedBorder: focusedOutlineInputBorder,
// //   errorBorder: errorOutlineInputBorder,
// // );
// //
// // const InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
// //   fillColor: darkGreyColor,
// //   filled: true,
// //   hintStyle: TextStyle(color: whileColor40),
// //   border: outlineInputBorder,
// //   enabledBorder: outlineInputBorder,
// //   focusedBorder: focusedOutlineInputBorder,
// //   errorBorder: errorOutlineInputBorder,
// // );
// //
// // const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
// //   borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
// //   borderSide: BorderSide(
// //     color: Colors.transparent,
// //   ),
// // );
// //
// // const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
// //   borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
// //   borderSide: BorderSide(color: primaryColor),
// // );
// //
// // const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
// //   borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
// //   borderSide: BorderSide(
// //     color: errorColor,
// //   ),
// // );
// //
// // OutlineInputBorder secondaryOutlineInputBorder(BuildContext context) {
// //   final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
// //   return OutlineInputBorder(
// //     borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
// //     borderSide: BorderSide(
// //       color: themeProvider.textColor.withOpacity(0.15),
// //     ),
// //   );
// // }
// theme/input_decoration_theme.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/theme/theme_data.dart';
import 'package:shop/theme/theme_provider.dart';
import '../constants.dart';

// الثيم الفاتح
InputDecorationTheme lightInputDecorationTheme(ThemeProvider theme) {
  return InputDecorationTheme(
    fillColor: theme.backgroundColor.withOpacity(0.1),
    filled: true,
    hintStyle: TextStyle(color: theme.textColor.withOpacity(0.4)),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedOutlineInputBorder(theme),
    errorBorder: errorOutlineInputBorder,
  );
}

// الثيم الداكن
InputDecorationTheme darkInputDecorationTheme(ThemeProvider theme) {
  return InputDecorationTheme(
    fillColor: theme.backgroundColor.withOpacity(0.1),
    filled: true,
    hintStyle: TextStyle(color: theme.textColor.withOpacity(0.4)),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedOutlineInputBorder(theme),
    errorBorder: errorOutlineInputBorder,
  );
}

// حدود الحقول الأساسية
const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
  borderSide: BorderSide(color: Colors.transparent),
);

// عند التركيز على الحقل
OutlineInputBorder focusedOutlineInputBorder(ThemeProvider theme) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    borderSide: BorderSide(color: theme.primaryColor),
  );
}

// عند وجود خطأ في الحقل
const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
  borderSide: BorderSide(color: errorColor),
);

// حدود ثانوية مخصصة للبحث مثلاً
OutlineInputBorder secondaryOutlineInputBorder(BuildContext context) {
  final theme = Provider.of<ThemeProvider>(context, listen: false);
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
    borderSide: BorderSide(
      color: theme.textColor.withOpacity(0.15),
    ),
  );
}
