import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../widgets/display_section.dart';
import '../widgets/keypads/basic_keypad.dart';
import '../widgets/keypads/programmer_keypad.dart';
import '../widgets/keypads/scientific_keypad.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);

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

    String getModeName() {
      switch (calcProvider.mode) {
        case CalculatorMode.basic:
          return 'Cơ Bản';
        case CalculatorMode.scientific:
          return 'Khoa Học';
        case CalculatorMode.programmer:
          return 'Lập Trình Viên';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Máy Tính ${getModeName()}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
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
