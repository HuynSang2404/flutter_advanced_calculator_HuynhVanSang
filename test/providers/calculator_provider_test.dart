import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:advanced_calculator/providers/calculator_provider.dart';
import 'package:advanced_calculator/services/storage_service.dart';
import 'package:advanced_calculator/models/calculator_mode.dart';

@GenerateMocks([StorageService])
import 'calculator_provider_test.mocks.dart';

void main() {
  late CalculatorProvider provider;
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    
    // Setup default mock behaviors
    when(mockStorage.getCalculatorModeIndex()).thenReturn(0);
    when(mockStorage.getHistory()).thenReturn([]);
    when(mockStorage.getMemoryValue()).thenReturn(0.0);
    when(mockStorage.getIsRadian()).thenReturn(true);
    when(mockStorage.saveCalculatorModeIndex(any)).thenAnswer((_) async {});
    when(mockStorage.saveHistory(any)).thenAnswer((_) async {});
    when(mockStorage.saveMemoryValue(any)).thenAnswer((_) async {});
    when(mockStorage.saveIsRadian(any)).thenAnswer((_) async {});
    
    provider = CalculatorProvider(mockStorage);
  });

  group('Basic Operations', () {
    test('Append numbers', () {
      provider.append('5');
      expect(provider.expression, '5');
      
      provider.append('3');
      expect(provider.expression, '53');
    });

    test('Clear expression', () {
      provider.append('123');
      provider.clear();
      expect(provider.expression, '');
      expect(provider.result, '');
    });

    test('Delete last character', () {
      provider.append('123');
      provider.delete();
      expect(provider.expression, '12');
    });

    test('Simple addition', () {
      provider.append('2');
      provider.append('+');
      provider.append('3');
      provider.evaluate();
      expect(provider.result, '5');
    });

    test('Simple multiplication', () {
      provider.append('4');
      provider.append('×');
      provider.append('5');
      provider.evaluate();
      expect(provider.result, '20');
    });
  });

  group('Mode Switching', () {
    test('Switch to scientific mode', () {
      provider.setMode(CalculatorMode.scientific);
      expect(provider.mode, CalculatorMode.scientific);
      verify(mockStorage.saveCalculatorModeIndex(1)).called(1);
    });

    test('Switch to programmer mode', () {
      provider.setMode(CalculatorMode.programmer);
      expect(provider.mode, CalculatorMode.programmer);
      verify(mockStorage.saveCalculatorModeIndex(2)).called(1);
    });

    test('Mode switch clears expression', () {
      provider.append('123');
      provider.setMode(CalculatorMode.scientific);
      expect(provider.expression, '');
    });
  });

  group('Angle Unit Toggle', () {
    test('Toggle from radian to degree', () {
      expect(provider.isRadian, true);
      provider.toggleAngleUnit();
      expect(provider.isRadian, false);
      verify(mockStorage.saveIsRadian(false)).called(1);
    });

    test('Toggle from degree to radian', () {
      provider.toggleAngleUnit(); // to degree
      provider.toggleAngleUnit(); // back to radian
      expect(provider.isRadian, true);
    });
  });

  group('Memory Functions', () {
    test('Memory clear', () {
      provider.memoryClear();
      verify(mockStorage.saveMemoryValue(0.0)).called(1);
    });

    test('Memory add', () {
      provider.append('5');
      provider.evaluate();
      provider.memoryAdd();
      verify(mockStorage.saveMemoryValue(5.0)).called(1);
    });

    test('Memory subtract', () {
      provider.append('3');
      provider.evaluate();
      provider.memorySubtract();
      verify(mockStorage.saveMemoryValue(-3.0)).called(1);
    });

    test('Memory read', () {
      when(mockStorage.getMemoryValue()).thenReturn(42.0);
      provider = CalculatorProvider(mockStorage);
      
      provider.memoryRead();
      expect(provider.expression, '42');
    });
  });

  group('History Management', () {
    test('History is saved after evaluation', () {
      provider.append('2');
      provider.append('+');
      provider.append('3');
      provider.evaluate();
      
      expect(provider.history.length, 1);
      expect(provider.history[0].expression, '2+3');
      expect(provider.history[0].result, '5');
      verify(mockStorage.saveHistory(any)).called(1);
    });

    test('History limit to 50 items', () {
      // Create 51 calculations
      for (int i = 0; i < 51; i++) {
        provider.append('1');
        provider.append('+');
        provider.append('1');
        provider.evaluate();
        provider.clear();
      }
      
      expect(provider.history.length, 50);
    });

    test('Error results are not saved to history', () {
      provider.append('5');
      provider.append('÷');
      provider.append('0');
      provider.evaluate();
      
      expect(provider.history.length, 0);
    });
  });

  group('Chain Calculations', () {
    test('Result becomes new expression after evaluation', () {
      provider.append('5');
      provider.append('+');
      provider.append('3');
      provider.evaluate();
      
      expect(provider.expression, '8');
      
      provider.append('+');
      provider.append('2');
      provider.evaluate();
      
      expect(provider.result, '10');
    });

    test('New number clears previous result', () {
      provider.append('5');
      provider.append('+');
      provider.append('3');
      provider.evaluate();
      
      provider.append('7'); // New number
      expect(provider.expression, '7');
    });

    test('Operator continues from previous result', () {
      provider.append('5');
      provider.append('+');
      provider.append('3');
      provider.evaluate();
      
      provider.append('+'); // Operator
      expect(provider.expression, '8+');
    });
  });

  group('Programmer Mode', () {
    test('Set base to hexadecimal', () {
      provider.setMode(CalculatorMode.programmer);
      provider.setBase(16);
      expect(provider.isHex, true);
    });

    test('Set base to binary', () {
      provider.setMode(CalculatorMode.programmer);
      provider.setBase(2);
      expect(provider.isBin, true);
    });

    test('Set base to decimal', () {
      provider.setMode(CalculatorMode.programmer);
      provider.setBase(10);
      expect(provider.isDec, true);
    });
    
    test('Programmer mode defaults to HEX', () {
      provider.setMode(CalculatorMode.programmer);
      expect(provider.isHex, true);
    });
  });
}
