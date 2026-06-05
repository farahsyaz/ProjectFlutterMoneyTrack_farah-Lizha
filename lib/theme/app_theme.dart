import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8CC0EB);
  static const Color light = Color(0xFFBFDDF0);
  static const Color accent = Color(0xFFFFEBCC);
  static const Color dark = Color(0xFF2D4A6B);
  static const Color darker = Color(0xFF1A2E42);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFD);
  static const Color textDark = Color(0xFF1A2E42);
  static const Color textMuted = Color(0xFF6B8CAE);
  static const Color success = Color(0xFF4CAF82);
  static const Color danger = Color(0xFFE57373);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE3EEF7);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.offWhite,
        background: AppColors.offWhite,
      ),
      scaffoldBackgroundColor: AppColors.offWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.dark),
        titleTextStyle: TextStyle(
          color: AppColors.dark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      cardTheme: CardThemeData(
  color: AppColors.cardBg,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: const BorderSide(color: AppColors.divider),
  ),
),
    );
  }
}
