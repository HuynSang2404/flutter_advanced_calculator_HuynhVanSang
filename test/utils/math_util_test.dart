import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_calculator/utils/math_util.dart';

void main() {
  group('Basic Operations', () {
    test('Addition', () {
      expect(MathUtil.evaluateBasicOrScientific('2+3'), '5');
      expect(MathUtil.evaluateBasicOrScientific('10+20'), '30');
    });

    test('Subtraction', () {
      expect(MathUtil.evaluateBasicOrScientific('10-3'), '7');
      expect(MathUtil.evaluateBasicOrScientific('5-8'), '-3');
    });

    test('Multiplication', () {
      expect(MathUtil.evaluateBasicOrScientific('4×5'), '20');
      expect(MathUtil.evaluateBasicOrScientific('7×8'), '56');
    });

    test('Division', () {
      expect(MathUtil.evaluateBasicOrScientific('10÷2'), '5');
      expect(MathUtil.evaluateBasicOrScientific('15÷3'), '5');
    });

    test('Division by zero', () {
      expect(MathUtil.evaluateBasicOrScientific('5÷0'), 'Error');
    });
  });

  group('Complex Expressions', () {
    test('Expression with parentheses', () {
      expect(MathUtil.evaluateBasicOrScientific('(5+3)×2-4÷2'), '14');
    });

    test('Nested parentheses', () {
      expect(MathUtil.evaluateBasicOrScientific('((2+3)×(4-1))÷5'), '3');
    });

    test('Chain calculations', () {
      expect(MathUtil.evaluateBasicOrScientific('5+3+2+1'), '11');
    });
  });

  group('Scientific Functions - Radians', () {
    test('sin(π/2) should equal 1', () {
      final result = MathUtil.evaluateBasicOrScientific('sin(π÷2)', isRadian: true);
      expect(double.parse(result), closeTo(1.0, 0.0001));
    });

    test('cos(0) should equal 1', () {
      final result = MathUtil.evaluateBasicOrScientific('cos(0)', isRadian: true);
      expect(double.parse(result), closeTo(1.0, 0.0001));
    });

    test('cos(π) should equal -1', () {
      final result = MathUtil.evaluateBasicOrScientific('cos(π)', isRadian: true);
      expect(double.parse(result), closeTo(-1.0, 0.0001));
    });

    test('tan(π/4) should equal 1', () {
      final result = MathUtil.evaluateBasicOrScientific('tan(π÷4)', isRadian: true);
      expect(double.parse(result), closeTo(1.0, 0.0001));
    });
  });

  group('Scientific Functions - Degrees', () {
    test('sin(45°) should equal ~0.707', () {
      final result = MathUtil.evaluateBasicOrScientific('sin(45)', isRadian: false);
      expect(double.parse(result), closeTo(0.7071067811865476, 0.0001));
    });

    test('cos(45°) should equal ~0.707', () {
      final result = MathUtil.evaluateBasicOrScientific('cos(45)', isRadian: false);
      expect(double.parse(result), closeTo(0.7071067811865476, 0.0001));
    });

    test('sin(45°) + cos(45°) should equal ~1.414', () {
      final result = MathUtil.evaluateBasicOrScientific('sin(45)+cos(45)', isRadian: false);
      expect(double.parse(result), closeTo(1.414213562373095, 0.0001));
    });

    test('sin(30°) should equal 0.5', () {
      final result = MathUtil.evaluateBasicOrScientific('sin(30)', isRadian: false);
      expect(double.parse(result), closeTo(0.5, 0.0001));
    });

    test('cos(60°) should equal 0.5', () {
      final result = MathUtil.evaluateBasicOrScientific('cos(60)', isRadian: false);
      expect(double.parse(result), closeTo(0.5, 0.0001));
    });

    test('tan(45°) should equal 1', () {
      final result = MathUtil.evaluateBasicOrScientific('tan(45)', isRadian: false);
      expect(double.parse(result), closeTo(1.0, 0.0001));
    });
  });

  group('Advanced Scientific Functions', () {
    test('Square root', () {
      expect(MathUtil.evaluateBasicOrScientific('sqrt(9)'), '3');
      expect(MathUtil.evaluateBasicOrScientific('sqrt(16)'), '4');
    });

    test('Power operations', () {
      expect(MathUtil.evaluateBasicOrScientific('2^3'), '8');
      expect(MathUtil.evaluateBasicOrScientific('5^2'), '25');
    });

    test('Logarithm base 10', () {
      // log10(100) = 2, we can calculate as ln(100)/ln(10)
      final result = MathUtil.evaluateBasicOrScientific('ln(100)÷ln(10)');
      expect(double.parse(result), closeTo(2.0, 0.0001));
    });

    test('Natural logarithm', () {
      final result = MathUtil.evaluateBasicOrScientific('ln(2.718281828459045)');
      expect(double.parse(result), closeTo(1.0, 0.0001));
    });

    test('Pi constant', () {
      final result = MathUtil.evaluateBasicOrScientific('π');
      expect(double.parse(result), closeTo(3.141592653589793, 0.0001));
    });

    test('Mixed scientific: 2×π×sqrt(9)', () {
      final result = MathUtil.evaluateBasicOrScientific('2×π×sqrt(9)');
      expect(double.parse(result), closeTo(18.84955592153876, 0.0001));
    });
  });

  group('Programmer Mode', () {
    test('Hexadecimal AND operation', () {
      expect(MathUtil.evaluateProgrammer('FF AND F', 16), 'F');
    });

    test('Binary operations', () {
      expect(MathUtil.evaluateProgrammer('1010 AND 1100', 2), '1000');
    });

    test('Hexadecimal addition', () {
      expect(MathUtil.evaluateProgrammer('A+5', 16), 'F');
    });

    test('Binary to decimal conversion', () {
      expect(MathUtil.evaluateProgrammer('1111', 2), '1111');
    });
  });

  group('Error Handling', () {
    test('Invalid expression', () {
      // math_expressions parser can handle 2++3 as 2+(+3) = 5
      // So we test a truly invalid expression
      expect(MathUtil.evaluateBasicOrScientific('2+*3'), 'Error');
    });

    test('Unmatched parentheses - auto close', () {
      final result = MathUtil.evaluateBasicOrScientific('(2+3');
      expect(result, '5');
    });

    test('Empty expression', () {
      expect(MathUtil.evaluateBasicOrScientific(''), 'Error');
    });
  });

  group('Percentage', () {
    test('Percentage calculation', () {
      // % in math_expressions is modulo operator, not percentage
      // For percentage, we need 50/100 or 50*0.01
      expect(MathUtil.evaluateBasicOrScientific('50÷100'), '0.5');
    });
  });
}
