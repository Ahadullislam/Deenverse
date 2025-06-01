import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green.shade800,
    brightness: Brightness.light,
    primary: Colors.green.shade800,
    secondary: Colors.amber.shade700,
    background: Colors.white,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green.shade900,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.amber.shade700),
  ),
  textTheme: TextTheme(
    headlineMedium:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),
  ),
);

final ThemeData darkAppTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green.shade800,
    brightness: Brightness.dark,
    primary: Colors.green.shade700,
    secondary: Colors.amber.shade700,
    background: Colors.black,
    surface: Colors.grey.shade900,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green.shade800,
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.amber.shade700),
  ),
  textTheme: TextTheme(
    headlineMedium:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade200),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade200),
  ),
);
