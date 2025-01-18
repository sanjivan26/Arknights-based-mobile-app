import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF2F3F4), 
    inverseSurface: Color(0xFF181818),
    surfaceTint: Color(0xFF6B6B6B),
    primary: Color(0xFFA133FF),
    primaryFixedDim : Color(0xFF555555),
    onError: Color.fromARGB(255, 255, 178, 161),
    secondary: Color(0xFFA133FF),
    tertiary: Color(0xFFA133FF),
    onSurface: const Color.fromARGB(255, 187, 187, 187),
    onSurfaceVariant: Colors.grey,
    surfaceContainer: Color(0xFFD3D3D3),
    surfaceContainerHigh: Color(0xFFD3D3D3),
  )
  );

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF181818),
    inverseSurface: Color(0xFFF2F3F4), 
    surfaceTint: Color(0xFF555555),
    primary: Color(0xFFA133FF),
    primaryFixedDim: Color(0xFF6B6B6B),
    onError: Color(0xFFFF9982),
    onSurface: Color.fromARGB(255, 85, 85, 85),
    onSurfaceVariant: Colors.grey,
    surfaceContainer: Color.fromARGB(255, 66, 66, 66),
    surfaceContainerHigh: Color.fromARGB(255, 191, 191, 191)
    
  )
);