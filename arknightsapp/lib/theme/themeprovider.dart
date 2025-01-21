import 'package:flutter/material.dart';
import './theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themedata = lightMode;

  ThemeData get themedata => _themedata;

  void setTheme(ThemeData themedata) {
    _themedata = themedata;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themedata == lightMode) {
      setTheme(darkMode);
    } else {
      setTheme(lightMode);
    }
  }
}
