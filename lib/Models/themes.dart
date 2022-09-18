import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xffe6e6e6),
  primaryColor: const Color(0xffe6e6e6),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff903aff),
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      const Color(0xffe6e6e6),
    ),
    foregroundColor: MaterialStateProperty.all<Color>(
      Colors.black,
    ),
  )),
);
