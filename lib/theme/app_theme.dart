import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF0B1E1B);
  static const surface = Color(0xFF102722);
  static const card = Color(0xFF15352E);
  static const green = Color(0xFF4DD0B1);
  static const darkGreen = Color(0xFFEAF7F3);
  static const muted = Color(0xFF8EADA5);
  static const border = Color(0xFF23483F);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: green,
        secondary: green,
        surface: surface,
        onPrimary: background,
        onSurface: darkGreen,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: darkGreen,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        hintStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: green),
        ),
      ),
    );
  }
}
