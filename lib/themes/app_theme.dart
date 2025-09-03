import 'package:flutter/material.dart';
import 'package:flutter/material.dart' show CardTheme, ThemeData, AppBarTheme, BorderRadius, BorderSide, RoundedRectangleBorder, IconThemeData, TextStyle, Colors, Brightness, ColorScheme, CardThemeData;
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primary.withOpacity(0.7),
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
      fontFamily: 'AlpenFont',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansJP',
        ),
        iconTheme: IconThemeData(
          color: AppColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        color: AppColors.surface,
      ),
    );
  }
}
