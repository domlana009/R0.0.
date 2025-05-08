import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme;
  ThemeData get currentTheme => _currentTheme;

  ThemeProvider() : _currentTheme = ThemeData.light() {
    loadTheme();
  }

  Future<void> toggleTheme() async {
    _currentTheme = _currentTheme == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light();
    notifyListeners();
    await saveTheme(_currentTheme == ThemeData.dark());
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _currentTheme = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  Future<void> saveTheme(bool isDarkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }
}