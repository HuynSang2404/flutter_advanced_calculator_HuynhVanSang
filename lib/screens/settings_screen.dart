import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart' as app_theme;
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: ListView(
        children: [
          // Theme Setting
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Giao Diện',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Chế độ giao diện'),
            subtitle: Text(_getThemeModeName(themeProvider.themeMode)),
          ),
          RadioListTile<app_theme.ThemeMode>(
            title: const Text('Sáng'),
            value: app_theme.ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) themeProvider.setThemeMode(mode);
            },
          ),
          RadioListTile<app_theme.ThemeMode>(
            title: const Text('Tối'),
            value: app_theme.ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) themeProvider.setThemeMode(mode);
            },
          ),
          RadioListTile<app_theme.ThemeMode>(
            title: const Text('Theo hệ thống'),
            value: app_theme.ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) themeProvider.setThemeMode(mode);
            },
          ),
          const Divider(),

          // Calculator Mode Setting
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Chế Độ Máy Tính',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<CalculatorMode>(
            title: const Text('Cơ bản'),
            subtitle: const Text('Các phép tính cơ bản'),
            value: CalculatorMode.basic,
            groupValue: calcProvider.mode,
            onChanged: (mode) {
              if (mode != null) calcProvider.setMode(mode);
            },
          ),
          RadioListTile<CalculatorMode>(
            title: const Text('Khoa học'),
            subtitle: const Text('Hàm lượng giác, logarit, mũ'),
            value: CalculatorMode.scientific,
            groupValue: calcProvider.mode,
            onChanged: (mode) {
              if (mode != null) calcProvider.setMode(mode);
            },
          ),
          RadioListTile<CalculatorMode>(
            title: const Text('Lập trình viên'),
            subtitle: const Text('Hệ nhị phân, thập lục phân, bitwise'),
            value: CalculatorMode.programmer,
            groupValue: calcProvider.mode,
            onChanged: (mode) {
              if (mode != null) calcProvider.setMode(mode);
            },
          ),
          const Divider(),

          // Angle Unit Setting (for Scientific mode)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Đơn Vị Góc',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.straighten),
            title: const Text('Radian'),
            subtitle: Text(calcProvider.isRadian 
                ? 'Đang dùng Radian' 
                : 'Đang dùng Độ (Degree)'),
            value: calcProvider.isRadian,
            onChanged: (value) {
              calcProvider.toggleAngleUnit();
            },
          ),
          const Divider(),

          // Feedback Settings
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Phản Hồi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: const Text('Âm thanh'),
            subtitle: const Text('Phát âm thanh khi bấm phím'),
            value: settingsProvider.soundEnabled,
            onChanged: (value) {
              settingsProvider.setSoundEnabled(value);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text('Rung'),
            subtitle: const Text('Rung khi bấm phím'),
            value: settingsProvider.vibrationEnabled,
            onChanged: (value) {
              settingsProvider.setVibrationEnabled(value);
            },
          ),
        ],
      ),
    );
  }

  String _getThemeModeName(app_theme.ThemeMode mode) {
    switch (mode) {
      case app_theme.ThemeMode.light:
        return 'Sáng';
      case app_theme.ThemeMode.dark:
        return 'Tối';
      case app_theme.ThemeMode.system:
        return 'Theo hệ thống';
    }
  }
}
