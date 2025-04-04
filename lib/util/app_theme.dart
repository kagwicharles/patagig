import 'package:flutter/material.dart';

class AppTheme {
  static final elevatedButtonThemeData = ElevatedButtonThemeData(
      style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(54))));

  static final lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
      elevatedButtonTheme: elevatedButtonThemeData);

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    fontFamily: 'Poppins',
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ).copyWith(elevatedButtonTheme: elevatedButtonThemeData);
}
