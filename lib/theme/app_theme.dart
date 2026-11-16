import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFFF8F9FC);
  static const purple = Color(0xFF7C3AED);
  static const equals = Color(0xFF6D28D9);
  static const ink = Color(0xFF1F2937);
  static const secondary = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: purple,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: ink, fontWeight: FontWeight.w600),
    ),
  );
}
