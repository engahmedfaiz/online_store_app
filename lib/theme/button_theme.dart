// theme/button_theme.dart
import 'package:flutter/material.dart';
import 'package:shop/theme/theme_data.dart';
import 'package:shop/theme/theme_provider.dart';

import '../constants.dart';

ElevatedButtonThemeData elevatedButtonThemeData(ThemeProvider theme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(defaultPadding),
      backgroundColor: theme.primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
    ),
  );
}

OutlinedButtonThemeData outlinedButtonTheme(ThemeProvider theme) {
  return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(defaultPadding),
        minimumSize: const Size(double.infinity, 32),
        side: BorderSide(width: 1.5, color: theme.textColor.withOpacity(0.1)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
        ),
      ));
}

TextButtonThemeData textButtonThemeData(ThemeProvider theme) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
  );
}