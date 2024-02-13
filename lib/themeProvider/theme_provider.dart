import 'package:flutter/material.dart';

class Themes{
  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 12, 12, 12),
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 121, 212, 223),
    colorScheme: ColorScheme.light(),
  );
}