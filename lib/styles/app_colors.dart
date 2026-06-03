import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета для темной темы
  static const primary = Color(0xFF8E44AD);
  static const lightPrimary = Color(0xFFAE49A1);
  static const complementaryBlue = Color(0xFF3498DB);
  static const onPrimary = Color(0xFFF5EEF8);
  static const secondary = Color(0xFF5B2C6F);
  static const onSecondary = Color(0xFFE8DAEF);
  static const background = Color(0xFF1C1C2E);
  static const onBackground = Color(0xFFEDE7F6);
  static const surface = Color(0xFF2B2B40);
  static const onSurface = Color(0xFFB39DDB);
  static const error = Color(0xFFE74C3C);
  static const onError = Color(0xFFFFCDD2);
  static const success = Color(0xFF27AE60);
  static const text = Color(0xFFF5F5F5);
  static const subText = Color(0xFFB2B2B2);

  static const button = Color(0xFF9B59B6);
  static const buttonText = Color(0xFFFFFFFF);
  static const divider = Color(0xFF4A4A5A);

  static const white = Color(0xFFffffff);
  static const checkStatus = Color(0xFFD57300);

  static const black = Color(0xFF000000);

  static ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    error: error,
    onError: onError,
    background: background,
    onBackground: onBackground,
    surface: surface,
    onSurface: onSurface,
    outline: Color(0xFFAAAAAA),
    shadow: Color(0xFF000000),
    outlineVariant: white,
  );
}
