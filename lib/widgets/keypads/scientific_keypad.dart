import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../calc_button.dart';
import '../long_press_calc_button.dart';

class ScientificKeypad extends StatelessWidget {
  const ScientificKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final accent = theme.colorScheme.secondary;

    Widget buildRow(List<Widget> buttons) {
      return Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons,
        ),
      );
    }

    return Column(
      children: [
        buildRow([
          CalcButton(text: 'sin', onTap: () => provider.append('sin('), color: primary),
          CalcButton(text: 'cos', onTap: () => provider.append('cos('), color: primary),
          CalcButton(text: 'tan', onTap: () => provider.append('tan('), color: primary),
          CalcButton(text: 'log', onTap: () => provider.append('log('), color: primary),
          CalcButton(text: 'ln', onTap: () => provider.append('ln('), color: primary),
          CalcButton(text: 'π', onTap: () => provider.append('π'), color: primary),
        ]),
        buildRow([
          CalcButton(text: 'e', onTap: () => provider.append('e'), color: primary),
          CalcButton(text: '^', onTap: () => provider.append('^'), color: primary),
          CalcButton(text: '√', onTap: () => provider.append('sqrt('), color: primary),
          CalcButton(text: '(', onTap: () => provider.append('('), color: primary),
          CalcButton(text: ')', onTap: () => provider.append(')'), color: primary),
          CalcButton(text: 'DEL', onTap: () => provider.delete(), color: primary),
        ]),
        buildRow([
          CalcButton(text: '7', onTap: () => provider.append('7')),
          CalcButton(text: '8', onTap: () => provider.append('8')),
          CalcButton(text: '9', onTap: () => provider.append('9')),
          LongPressCalcButton(
            text: 'AC', 
            onTap: () => provider.clear(), 
            onLongPress: () {
              provider.clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa lịch sử'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            color: accent, 
            textColor: theme.colorScheme.surface,
          ),
          CalcButton(text: 'MC', onTap: () => provider.memoryClear(), color: primary),
          CalcButton(text: 'MR', onTap: () => provider.memoryRead(), color: primary),
        ]),
        buildRow([
          CalcButton(text: '4', onTap: () => provider.append('4')),
          CalcButton(text: '5', onTap: () => provider.append('5')),
          CalcButton(text: '6', onTap: () => provider.append('6')),
          CalcButton(text: '÷', onTap: () => provider.append('÷'), color: primary),
          CalcButton(text: 'M+', onTap: () => provider.memoryAdd(), color: primary),
          CalcButton(text: 'M-', onTap: () => provider.memorySubtract(), color: primary),
        ]),
        buildRow([
          CalcButton(text: '1', onTap: () => provider.append('1')),
          CalcButton(text: '2', onTap: () => provider.append('2')),
          CalcButton(text: '3', onTap: () => provider.append('3')),
          CalcButton(text: '×', onTap: () => provider.append('×'), color: primary),
          CalcButton(text: 'EXP', onTap: () => provider.append('EXP'), color: primary),
          CalcButton(text: '%', onTap: () => provider.append('%'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '0', onTap: () => provider.append('0')),
          CalcButton(text: '.', onTap: () => provider.append('.')),
          CalcButton(text: '=', onTap: () => provider.evaluate(), color: accent, textColor: theme.colorScheme.surface),
          CalcButton(text: '+', onTap: () => provider.append('+'), color: primary),
          CalcButton(text: '-', onTap: () => provider.append('-'), color: primary),
          CalcButton(text: '1/x', onTap: () => provider.append('^(-1)'), color: primary),
        ]),
      ],
    );
  }
}
