import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/display_section.dart';
import '../widgets/keypads/basic_keypad.dart';
import '../widgets/keypads/programmer_keypad.dart';
import '../widgets/keypads/scientific_keypad.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget getKeypad() {
      switch (calcProvider.mode) {
        case CalculatorMode.basic:
          return const BasicKeypad();
        case CalculatorMode.scientific:
          return const ScientificKeypad();
        case CalculatorMode.programmer:
          return const ProgrammerKeypad();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          PopupMenuButton<CalculatorMode>(
            initialValue: calcProvider.mode,
            onSelected: (CalculatorMode mode) {
              calcProvider.setMode(mode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CalculatorMode.basic,
                child: Text('Basic'),
              ),
              const PopupMenuItem(
                value: CalculatorMode.scientific,
                child: Text('Scientific'),
              ),
              const PopupMenuItem(
                value: CalculatorMode.programmer,
                child: Text('Programmer'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 4,
              child: DisplaySection(),
            ),
            const Divider(height: 1),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<CalculatorMode>(calcProvider.mode),
                    child: getKeypad(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
