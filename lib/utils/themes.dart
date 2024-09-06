import 'package:flutter/material.dart';

class Themes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.blueAccent,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black54),
      titleSmall: TextStyle(color: Colors.blueAccent),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[800],
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.blueAccent,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white54),
      titleSmall: TextStyle(color: Colors.blueAccent),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );
}