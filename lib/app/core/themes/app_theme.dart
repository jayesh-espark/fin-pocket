import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF51014), // main red
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF51014),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF51014),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF51014),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
      bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFF51014),
      secondary: const Color(0xFFFF6B6B), // accent red
      background: Colors.white,
      surface: Colors.grey[100]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
  );

  // Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0A1F44), // navy blue
    scaffoldBackgroundColor: const Color(0xFF0A1F44),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A1F44),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1B365F),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B365F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white60, fontSize: 12),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF0A1F44),
      secondary: const Color(0xFF1B365F),
      background: const Color(0xFF0A1F44),
      surface: const Color(0xFF12284D),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
  );
}
