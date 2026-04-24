import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advanced_calculator/providers/calculator_provider.dart';
import 'package:advanced_calculator/providers/theme_provider.dart' as app_theme;
import 'package:advanced_calculator/providers/settings_provider.dart';
import 'package:advanced_calculator/services/storage_service.dart';
import 'package:advanced_calculator/screens/calculator_screen.dart';
import 'package:advanced_calculator/utils/theme_config.dart';

void main() {
  testWidgets('Calculator app smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();

    // Build our app with providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => app_theme.ThemeProvider(storageService)),
          ChangeNotifierProvider(create: (_) => CalculatorProvider(storageService)),
          ChangeNotifierProvider(create: (_) => SettingsProvider(storageService)),
        ],
        child: MaterialApp(
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          home: const CalculatorScreen(),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the app title is displayed (starts with "Máy Tính")
    expect(find.textContaining('Máy Tính'), findsOneWidget);

    // Verify that AppBar exists
    expect(find.byType(AppBar), findsOneWidget);
    
    // Verify that Settings button exists
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
