import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromARGB(255, 52, 168, 245);
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color background = Color.fromARGB(255, 202, 202, 202);
  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: const Color.fromARGB(255, 56, 170, 245),
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBarTheme: const AppBarTheme(
        color: primary,
        elevation: 0,
      ));
}
