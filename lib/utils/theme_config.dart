import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color lightPrimary = Color(0xFF1E1E1E);
  static const Color lightAccent = Color(0xFFFF6B6B);
  static const Color lightBackground = Color(0xFFF0F0F0); 
  static const Color lightDisplay = Color(0xFFFFFFFF);

  static const Color darkPrimary = Color(0xFF121212);
  static const Color darkAccent = Color(0xFF4ECDC4);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkDisplay = Color(0xFF1A1A1A);

  // Setup giao diện nền sáng
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightAccent,
        surface: lightDisplay,
        onSurface: Colors.black,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }

  // Setup giao diện nền tối
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkAccent,
        surface: darkDisplay,
        onSurface: Colors.white,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }
}
