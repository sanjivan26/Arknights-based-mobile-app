import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF2F3F4), 
    inverseSurface: Color(0xFF181818),
    surfaceTint: Color.fromARGB(255, 170, 170, 170),
    primary: Color(0xFF181818),
    primaryFixedDim : Color.fromARGB(255, 130, 130, 130),
    onError: Color.fromARGB(255, 255, 178, 161),
    onTertiary: const Color.fromARGB(255, 187, 187, 187),
    onSecondary: Colors.grey,
    surfaceContainer: Color(0xFFD3D3D3),
    surfaceContainerHigh: Color(0xFFD3D3D3),
    onSurface: Color.fromARGB(255, 77, 77, 77),

  )
  );

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF181818),
    inverseSurface: Color(0xFFF2F3F4), 
    surfaceTint: Color(0xFF555555),
    primary: Color(0xFFF2F3F4),
    primaryFixedDim: Color(0xFF6B6B6B),
    onError: Color.fromARGB(255, 255, 121, 91),
    onTertiary: Color.fromARGB(255, 62, 62, 62),
    onSecondary: Color.fromARGB(255, 117, 117, 117),
    surfaceContainer: Color.fromARGB(255, 66, 66, 66),
    surfaceContainerHigh: Color.fromARGB(255, 191, 191, 191),
    onSurface: Color.fromARGB(255, 194, 194, 194),
  )
);