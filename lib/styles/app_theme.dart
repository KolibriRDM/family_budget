import 'package:family_budget/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class AppTheme {
  AppTheme._();

  static const double offset = 16;
  static const double radius = 10.0;
  static const double elevation = 6.0;
  static const double iconSize = 18.0;
  static const circularRadius = BorderRadius.all(Radius.circular(radius));
  static const boxShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 13,
      offset: Offset(1, 4),
    ),
  ];

  // Создаем переиспользуемые стили текста для приложения
  static TextStyle _createTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    FontStyle? fontStyle,
    String fontFamily = 'Inter',
  }) {
    if (fontFamily == 'Inter') {
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
      );
    } else if (fontFamily == 'Montserrat') {
      return GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
      );
    }

    // По умолчанию Inter
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static final TextTheme _textTheme = TextTheme(
    displayLarge: _createTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    ),
    displayMedium: _createTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    ),
    displaySmall: _createTextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      color: AppColors.white,
    ),
    titleLarge: _createTextStyle(
      fontSize: 19,
      fontWeight: FontWeight.normal,
      color: AppColors.onPrimary,
    ),
    titleMedium: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    titleSmall: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.white,
    ),
    bodyLarge: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
      fontFamily: 'Montserrat',
    ),
    bodyMedium: _createTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
    bodySmall: _createTextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.white,
    ),
    labelLarge: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: AppColors.white,
    ),
    labelMedium: _createTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.white.withOpacity(0.7),
    ),
    labelSmall: _createTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.subText,
    ),
  );

  static final TextTheme _textLightTheme = TextTheme(
    displayLarge: _createTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    displayMedium: _createTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    displaySmall: _createTextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      color: AppColors.black,
    ),
    titleLarge: _createTextStyle(
      fontSize: 19,
      fontWeight: FontWeight.normal,
      color: AppColors.background,
    ),
    titleMedium: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    titleSmall: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    bodyLarge: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
      fontFamily: 'Montserrat',
    ),
    bodyMedium: _createTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
    bodySmall: _createTextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    labelLarge: _createTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: AppColors.black,
    ),
    labelMedium: _createTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.black.withOpacity(0.7),
    ),
    labelSmall: _createTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.divider,
    ),
  );

  static final primaryTextTheme = _textTheme.copyWith(
    displayLarge: _textTheme.displayLarge?.copyWith(color: AppColors.primary),
    displayMedium: _textTheme.displayMedium?.copyWith(color: AppColors.primary),
    displaySmall: _textTheme.displaySmall?.copyWith(color: AppColors.primary),
    headlineLarge: _textTheme.headlineLarge?.copyWith(color: AppColors.primary),
    titleLarge: _textTheme.titleLarge?.copyWith(color: AppColors.primary),
    titleMedium: _textTheme.titleMedium?.copyWith(color: AppColors.primary),
    titleSmall: _textTheme.titleSmall?.copyWith(color: AppColors.primary),
    bodyLarge: _textTheme.bodyLarge?.copyWith(color: AppColors.primary),
    bodyMedium: _textTheme.bodyMedium?.copyWith(color: AppColors.primary),
    bodySmall: _textTheme.bodySmall?.copyWith(color: AppColors.primary),
    labelLarge: _textTheme.labelLarge?.copyWith(color: AppColors.primary),
    labelMedium: _textTheme.labelMedium?.copyWith(color: AppColors.primary),
    labelSmall: _textTheme.labelSmall?.copyWith(color: AppColors.primary),
  );

  static final theme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.colorScheme,
    scaffoldBackgroundColor: AppColors.colorScheme.background,
    // scaffoldBackgroundColor: AppColors.colorScheme.outlineVariant,
    useMaterial3: false,

    textTheme: _textTheme,
    // textTheme: _textLightTheme,
    primaryTextTheme: primaryTextTheme,

    dividerColor: AppColors.colorScheme.primary,

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF2072CC),
      ),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.text,
      ),
      centerTitle: true,
      titleTextStyle: _textTheme.headlineMedium,
      backgroundColor: AppColors.colorScheme.background,
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      backgroundColor: AppColors.colorScheme.onBackground,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: _createTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.colorScheme.outline),
      unselectedLabelStyle: _createTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.colorScheme.secondary),
      selectedItemColor: AppColors.colorScheme.secondary,
      unselectedItemColor: AppColors.colorScheme.outline,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.background,
      headerBackgroundColor: AppColors.colorScheme.primary,
      headerForegroundColor: AppColors.white,
      dayStyle: _textTheme.bodySmall?.copyWith(color: AppColors.text),
      todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.colorScheme.primary;
        }
        return AppColors.onSecondary;
      }),
      todayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.white; // Цвет текста при выборе
        }
        return AppColors.white;
      }),
      dayForegroundColor: MaterialStateProperty.all(AppColors.text),
      yearForegroundColor: MaterialStateProperty.all(AppColors.text),
      yearBackgroundColor: MaterialStateProperty.all(AppColors.background),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.colorScheme.primary,
        textStyle: _textTheme.headlineSmall
            ?.copyWith(color: AppColors.colorScheme.primary),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.colorScheme.primary,
        textStyle: _textTheme.headlineSmall
            ?.copyWith(color: AppColors.colorScheme.primary),
      ),
      surfaceTintColor: Colors.transparent,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
  );
}
