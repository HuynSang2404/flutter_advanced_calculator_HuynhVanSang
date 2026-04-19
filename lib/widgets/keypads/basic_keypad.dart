import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../calc_button.dart';

class BasicKeypad extends StatelessWidget {
  const BasicKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context, listen: false);
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final primary = theme.colorScheme.primary;

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
          CalcButton(text: 'MC', onTap: () => provider.memoryClear(), color: primary),
          CalcButton(text: 'MR', onTap: () => provider.memoryRead(), color: primary),
          CalcButton(text: 'M-', onTap: () => provider.memorySubtract(), color: primary),
          CalcButton(text: 'M+', onTap: () => provider.memoryAdd(), color: primary),
        ]),
        buildRow([
          CalcButton(text: 'AC', onTap: () => provider.clear(), color: accent, textColor: theme.colorScheme.surface),
          CalcButton(text: 'DEL', onTap: () => provider.delete(), color: primary),
          CalcButton(text: '(', onTap: () => provider.append('('), color: primary),
          CalcButton(text: ')', onTap: () => provider.append(')'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '7', onTap: () => provider.append('7')),
          CalcButton(text: '8', onTap: () => provider.append('8')),
          CalcButton(text: '9', onTap: () => provider.append('9')),
          CalcButton(text: '÷', onTap: () => provider.append('÷'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '4', onTap: () => provider.append('4')),
          CalcButton(text: '5', onTap: () => provider.append('5')),
          CalcButton(text: '6', onTap: () => provider.append('6')),
          CalcButton(text: '×', onTap: () => provider.append('×'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '1', onTap: () => provider.append('1')),
          CalcButton(text: '2', onTap: () => provider.append('2')),
          CalcButton(text: '3', onTap: () => provider.append('3')),
          CalcButton(text: '-', onTap: () => provider.append('-'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '0', onTap: () => provider.append('0'), flex: 2),
          CalcButton(text: '.', onTap: () => provider.append('.')),
          CalcButton(text: '=', onTap: () => provider.evaluate(), color: accent, textColor: theme.colorScheme.surface),
          CalcButton(text: '+', onTap: () => provider.append('+'), color: primary),
        ]),
      ],
    );
  }
}
