import 'package:flutter/material.dart';

/// Bright green + white style inspired by "Айыл Банк" vibe (approx.).
class AppTheme {
  static const Color brandGreen = Color(0xFF00A859);
  static const Color brandGreenDark = Color(0xFF008A49);
  static const Color brandBg = Color(0xFFF6FFF9);
  static const Color brandSurface = Colors.white;

  static ThemeData light() {
    final cs = ColorScheme.fromSeed(
      seedColor: brandGreen,
      brightness: Brightness.light,
      primary: brandGreen,
      secondary: brandGreenDark,
      surface: brandSurface,
      background: brandBg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: brandBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      // NOTE: Avoid CardTheme to prevent analyzer issues on some Flutter setups.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: brandGreen, width: 1.6),
        ),
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.45)),
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.65)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: brandGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandGreenDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brandSurface,
        selectedColor: brandGreen.withOpacity(0.12),
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.75)),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        side: BorderSide(color: Colors.black.withOpacity(0.08)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerColor: Colors.black.withOpacity(0.08),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: brandSurface,
        selectedItemColor: brandGreen,
        unselectedItemColor: Colors.black.withOpacity(0.45),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.9),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.3),
      ),
    );
  }
}
