import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart' as app_theme;
import 'providers/settings_provider.dart';
import 'screens/calculator_screen.dart';
import 'services/storage_service.dart';
import 'utils/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_theme.ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => CalculatorProvider(storageService)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storageService)),
      ],
      child: const AdvancedCalculatorApp(),
    ),
  );
}

class AdvancedCalculatorApp extends StatelessWidget {
  const AdvancedCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context);

    ThemeMode getFlutterThemeMode() {
      switch (themeProvider.themeMode) {
        case app_theme.ThemeMode.light:
          return ThemeMode.light;
        case app_theme.ThemeMode.dark:
          return ThemeMode.dark;
        case app_theme.ThemeMode.system:
          return ThemeMode.system;
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calculator',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: getFlutterThemeMode(),
      home: const CalculatorScreen(),
    );
  }
}
