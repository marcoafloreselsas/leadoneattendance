import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary = Colors.indigo;
  static const Color background = Color.fromARGB(255, 202, 202, 202);
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.indigo,
    backgroundColor: Color.fromARGB(255, 233, 233, 233),
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    )

  );
}