import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum ThemeMode { light, dark, system }

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode;

  ThemeProvider(this._storageService) 
      : _themeMode = _storageService.getThemeMode();

  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _storageService.saveThemeMode(mode);
    notifyListeners();
  }
  
  // Giữ lại để tương thích với code cũ
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
