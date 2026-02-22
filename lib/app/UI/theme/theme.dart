// theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart'; // ajusta ruta

ThemeData buildAppTheme() {
  final seed = APP_PRIMARY_COLOR;

  // Usar Material 3 para aprovechar ColorScheme.fromSeed si quieres
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light, secondary: APP_ACCENT_COLOR);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: APP_PRIMARY_COLOR,
    primaryColorLight: APP_PRIMARY_COLOR_LIGHT,
    primaryColorDark: APP_PRIMARY_COLOR_DARK,
    scaffoldBackgroundColor: APP_BACKGROUND_COLOR,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 2,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Text theme: aquí puedes personalizar tipografías
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16.0),
    ),

    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),

    // Outlined / Text buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: colorScheme.primary.withOpacity(0.9)),
      ),
    ),

    // Input decorations
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: APP_SURFACE_ALT,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      errorStyle: const TextStyle(fontSize: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.15))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2)),
    ),

    // Cards
    cardTheme: CardTheme(
      color: APP_SURFACE_COLOR,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary,
      foregroundColor: Colors.white,
    ),

    // Snackbars, dialogs, etc. heredan colorScheme.
  );
}