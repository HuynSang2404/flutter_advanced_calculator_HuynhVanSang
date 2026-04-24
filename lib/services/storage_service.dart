import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';
import '../providers/theme_provider.dart';

class StorageService {
  static const String _keyHistory = 'history';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyMode = 'calculatorMode';
  static const String _keyIsRadian = 'isRadian';
  static const String _keyMemory = 'memoryValue';
  static const String _keySoundEnabled = 'soundEnabled';
  static const String _keyVibrationEnabled = 'vibrationEnabled';
  static const String _keyAnimationEnabled = 'animationEnabled';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Lưu và đọc Theme Mode (Light/Dark/System)
  ThemeMode getThemeMode() {
    final index = _prefs.getInt(_keyThemeMode) ?? 2; // Default: System
    return ThemeMode.values[index];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_keyThemeMode, mode.index);
  }
  
  // Giữ lại để tương thích
  bool getThemeIsDark() {
    final mode = getThemeMode();
    return mode == ThemeMode.dark;
  }

  Future<void> saveThemeIsDark(bool isDark) async {
    await saveThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // Lưu và đọc chế độ máy tính (Basic, Scientific, Programmer)
  int getCalculatorModeIndex() {
    return _prefs.getInt(_keyMode) ?? 0;
  }

  Future<void> saveCalculatorModeIndex(int index) async {
    await _prefs.setInt(_keyMode, index);
  }

  // Cài đặt đơn vị Góc (Radian hay Degree)
  bool getIsRadian() {
    return _prefs.getBool(_keyIsRadian) ?? false; // Default: false = DEGREE mode
  }

  Future<void> saveIsRadian(bool isRadian) async {
    await _prefs.setBool(_keyIsRadian, isRadian);
  }

  // Cache của bộ nhớ tạm (Cho các nút M+, M-)
  double getMemoryValue() {
    return _prefs.getDouble(_keyMemory) ?? 0.0;
  }

  Future<void> saveMemoryValue(double value) async {
    await _prefs.setDouble(_keyMemory, value);
  }

  // Đọc và ghi danh sách lịch sử tính toán (Lưu dưới dạng chuỗi Json)
  List<HistoryItem> getHistory() {
    final String? historyJson = _prefs.getString(_keyHistory);
    if (historyJson == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(historyJson);
      return decodedList.map((e) => HistoryItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveHistory(List<HistoryItem> history) async {
    final String encodedList = jsonEncode(history.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyHistory, encodedList);
  }

  // Âm thanh
  bool getSoundEnabled() {
    return _prefs.getBool(_keySoundEnabled) ?? true; // Default: bật
  }

  Future<void> saveSoundEnabled(bool enabled) async {
    await _prefs.setBool(_keySoundEnabled, enabled);
  }

  // Rung
  bool getVibrationEnabled() {
    return _prefs.getBool(_keyVibrationEnabled) ?? true; // Default: bật
  }

  Future<void> saveVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_keyVibrationEnabled, enabled);
  }

  // Hoạt ảnh
  bool getAnimationEnabled() {
    return _prefs.getBool(_keyAnimationEnabled) ?? true; // Default: bật
  }

  Future<void> saveAnimationEnabled(bool enabled) async {
    await _prefs.setBool(_keyAnimationEnabled, enabled);
  }
}
