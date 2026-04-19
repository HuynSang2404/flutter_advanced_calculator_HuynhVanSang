import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../calc_button.dart';

class ProgrammerKeypad extends StatelessWidget {
  const ProgrammerKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
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

    final bool isHex = provider.isHex;
    final bool isDec = provider.isDec;
    final bool isBin = provider.isBin;

    Color _getBaseColor(bool active) => active ? accent : primary;

    return Column(
      children: [
        buildRow([
          CalcButton(text: 'HEX', onTap: () => provider.setBase(16), color: _getBaseColor(isHex)),
          CalcButton(text: 'DEC', onTap: () => provider.setBase(10), color: _getBaseColor(isDec)),
          CalcButton(text: 'BIN', onTap: () => provider.setBase(2), color: _getBaseColor(isBin)),
          CalcButton(text: 'AC', onTap: () => provider.clear(), color: accent, textColor: theme.colorScheme.surface),
          CalcButton(text: 'DEL', onTap: () => provider.delete(), color: primary),
        ]),
        buildRow([
          CalcButton(text: 'A', onTap: isHex ? () => provider.append('A') : () {}, color: primary),
          CalcButton(text: 'B', onTap: isHex ? () => provider.append('B') : () {}, color: primary),
          CalcButton(text: 'AND', onTap: () => provider.append(' AND '), color: primary),
          CalcButton(text: 'OR', onTap: () => provider.append(' OR '), color: primary),
          CalcButton(text: 'XOR', onTap: () => provider.append(' XOR '), color: primary),
        ]),
        buildRow([
          CalcButton(text: 'C', onTap: isHex ? () => provider.append('C') : () {}, color: primary),
          CalcButton(text: 'D', onTap: isHex ? () => provider.append('D') : () {}, color: primary),
          CalcButton(text: 'LSH', onTap: () => provider.append(' LSH '), color: primary),
          CalcButton(text: 'RSH', onTap: () => provider.append(' RSH '), color: primary),
          CalcButton(text: '÷', onTap: () => provider.append('÷'), color: primary),
        ]),
        buildRow([
          CalcButton(text: 'E', onTap: isHex ? () => provider.append('E') : () {}, color: primary),
          CalcButton(text: 'F', onTap: isHex ? () => provider.append('F') : () {}, color: primary),
          CalcButton(text: '7', onTap: isDec || isHex ? () => provider.append('7') : () {}),
          CalcButton(text: '8', onTap: isDec || isHex ? () => provider.append('8') : () {}),
          CalcButton(text: '9', onTap: isDec || isHex ? () => provider.append('9') : () {}),
          CalcButton(text: '×', onTap: () => provider.append('×'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '4', onTap: isDec || isHex ? () => provider.append('4') : () {}),
          CalcButton(text: '5', onTap: isDec || isHex ? () => provider.append('5') : () {}),
          CalcButton(text: '6', onTap: isDec || isHex ? () => provider.append('6') : () {}),
          CalcButton(text: '-', onTap: () => provider.append('-'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '1', onTap: () => provider.append('1')),
          CalcButton(text: '2', onTap: isDec || isHex ? () => provider.append('2') : () {}),
          CalcButton(text: '3', onTap: isDec || isHex ? () => provider.append('3') : () {}),
          CalcButton(text: '+', onTap: () => provider.append('+'), color: primary),
        ]),
        buildRow([
          CalcButton(text: '0', onTap: () => provider.append('0'), flex: 2),
          CalcButton(text: '=', onTap: () => provider.evaluate(), flex: 2, color: accent, textColor: theme.colorScheme.surface),
        ]),
      ],
    );
  }
}
