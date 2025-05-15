// theme_colors_model.dart
import 'package:flutter/material.dart';

class ThemeColorsModel {
  final String id;
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;
  final String backgroundColor;
  final String? fontFamily;
  final bool isActive;
  final String storeId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ThemeColorsModel({
    required this.id,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    this.fontFamily,
    required this.isActive,
    required this.storeId,
    required this.createdAt,
    this.updatedAt,
  });

  factory ThemeColorsModel.fromJson(Map<String, dynamic> json) {
    return ThemeColorsModel(
      id: json['id'] ?? '',
      primaryColor: json['primaryColor'] ?? '#6200EE',
      secondaryColor: json['secondaryColor'] ?? '#03DAC6',
      accentColor: json['accentColor'] ?? '#FF4081',
      backgroundColor: json['backgroundColor'] ?? '#FFFFFF',
      fontFamily: json['fontFamily'],
      isActive: json['isActive'] ?? true,
      storeId: json['storeId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add opacity if not present
    }
    return Color(int.parse(hex, radix: 16));
  }

  Map<String, Color> toColorMap() {
    return {
      'primaryColor': hexToColor(primaryColor),
      'secondaryColor': hexToColor(secondaryColor),
      'accentColor': hexToColor(accentColor),
      'backgroundColor': hexToColor(backgroundColor),
    };
  }
}