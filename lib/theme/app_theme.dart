import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/theme/button_theme.dart';
import 'package:shop/theme/checkbox_themedata.dart';
import 'package:shop/theme/input_decoration_theme.dart';
import 'package:shop/theme/theme_data.dart';
import 'package:shop/theme/theme_provider.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customization = themeProvider.customization;

    return ThemeData(
      brightness: Brightness.light,
      fontFamily: customization?.fontFamily ?? "Plus Jakarta",
      primarySwatch: themeProvider.primaryMaterialColor,
      primaryColor: themeProvider.primaryColor,
      scaffoldBackgroundColor:       themeProvider.backgroundColor,

      iconTheme: IconThemeData(color: themeProvider.textColor),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: themeProvider.primaryMaterialColor.withOpacity(0.6)),
      ),
      elevatedButtonTheme: elevatedButtonThemeData(themeProvider),
      textButtonTheme: textButtonThemeData(themeProvider),
      outlinedButtonTheme: outlinedButtonTheme(themeProvider),
      inputDecorationTheme: lightInputDecorationTheme(themeProvider),
      checkboxTheme: checkboxThemeData.copyWith(
        side: BorderSide(color: themeProvider.backgroundColor.withOpacity(0.4)),
      ),
      colorScheme: ColorScheme.light(
        primary: themeProvider.primaryColor,
        secondary: themeProvider.secondaryColor,
        background: themeProvider.backgroundColor,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final customization = themeProvider.customization;

    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: customization?.fontFamily ?? "Plus Jakarta",
      primarySwatch: themeProvider.primaryMaterialColor,
      primaryColor: themeProvider.primaryColor,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.white.withOpacity(0.8)),
      ),
      elevatedButtonTheme: elevatedButtonThemeData(themeProvider),
      textButtonTheme: textButtonThemeData(themeProvider),
      outlinedButtonTheme: outlinedButtonTheme(themeProvider),
      inputDecorationTheme: lightInputDecorationTheme(themeProvider).copyWith(
        hintStyle: TextStyle(color: Colors.white54),
      ),
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: Colors.white54),
        checkColor: MaterialStateProperty.all(Colors.black),
        fillColor: MaterialStateProperty.all(themeProvider.primaryColor),
      ),
      colorScheme: ColorScheme.dark(
        primary: themeProvider.primaryColor,
        secondary: themeProvider.secondaryColor,
        background: Colors.black,
      ),
    );
  }
}
