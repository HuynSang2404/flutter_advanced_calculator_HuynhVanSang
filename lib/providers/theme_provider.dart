import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService;
  bool _isDarkMode;

  ThemeProvider(this._storageService) : _isDarkMode = _storageService.getThemeIsDark();

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storageService.saveThemeIsDark(_isDarkMode);
    notifyListeners();
  }
}
