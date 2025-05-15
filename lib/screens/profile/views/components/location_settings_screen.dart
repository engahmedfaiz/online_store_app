// 📁 screens/location_settings_screen.dart
import 'package:flutter/material.dart';

class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إعدادات الموقع")),
      body: const Center(child: Text("إعدادات الموقع")),
    );
  }
}