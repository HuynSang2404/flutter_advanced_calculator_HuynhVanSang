import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advanced_calculator/providers/calculator_provider.dart';
import 'package:advanced_calculator/providers/theme_provider.dart';
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
          ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
          ChangeNotifierProvider(create: (_) => CalculatorProvider(storageService)),
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

    // Verify that the app title is displayed
    expect(find.text('Advanced Calculator'), findsOneWidget);

    // Verify that AppBar exists
    expect(find.byType(AppBar), findsOneWidget);
  });
}
