import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF4DD0B1);

  static const darkBackground = Color(0xFF0B1E1B);
  static const darkSurface = Color(0xFF102722);
  static const darkCard = Color(0xFF15352E);
  static const darkText = Color(0xFFEAF7F3);
  static const darkMuted = Color(0xFF8EADA5);
  static const darkBorder = Color(0xFF23483F);

  static const lightBackground = Color(0xFFF3F8F6);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFEAF7F3);
  static const lightText = Color(0xFF15352E);
  static const lightMuted = Color(0xFF718780);
  static const lightBorder = Color(0xFFD5E5DF);

  static const background = darkBackground;
  static const surface = darkSurface;
  static const card = darkCard;
  static const muted = darkMuted;
  static const border = darkBorder;

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color surfaceColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color textColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color mutedColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkMuted : lightMuted;

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkBorder
      : lightBorder;

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    background: darkBackground,
    surface: darkSurface,
    card: darkCard,
    text: darkText,
    muted: darkMuted,
    border: darkBorder,
  );

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    background: lightBackground,
    surface: lightSurface,
    card: lightCard,
    text: lightText,
    muted: lightMuted,
    border: lightBorder,
  );

  static ThemeData get theme => darkTheme;

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color card,
    required Color text,
    required Color muted,
    required Color border,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: green,
        secondary: green,
        surface: surface,
        error: Colors.red,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: text,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: green),
        ),
      ),
    );
  }
}
