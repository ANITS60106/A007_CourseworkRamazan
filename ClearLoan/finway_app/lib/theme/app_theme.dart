import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF6EFE9),
      primaryColor: const Color(0xFFE6C58F),
      fontFamily: 'SF Pro',
      useMaterial3: true,
    );
  }
}