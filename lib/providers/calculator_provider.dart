import 'package:flutter/material.dart';
import '../models/calculator_mode.dart';
import '../models/history_item.dart';
import '../services/storage_service.dart';
import '../utils/math_util.dart';

class CalculatorProvider with ChangeNotifier {
  final StorageService _storageService;

  CalculatorMode _mode = CalculatorMode.basic;
  String _expression = '';
  String _result = '';
  List<HistoryItem> _history = [];
  double _memoryValue = 0.0;
  bool _isRadian = true;
  int _currentBase = 10; // Quản lý hệ cơ số (10, 2, 16)
  bool _shouldClear = false; // Xóa chuỗi nếu nhập số mới ngay sau khi bấm =
  
  bool get isHex => _currentBase == 16;
  bool get isBin => _currentBase == 2;
  bool get isDec => _currentBase == 10;

  CalculatorProvider(this._storageService) {
    _initVals();
  }

  void _initVals() {
    int mIdx = _storageService.getCalculatorModeIndex();
    _mode = CalculatorMode.values[mIdx];
    _history = _storageService.getHistory();
    _memoryValue = _storageService.getMemoryValue();
    _isRadian = _storageService.getIsRadian();
    notifyListeners();
  }

  CalculatorMode get mode => _mode;
  String get expression => _expression;
  String get result => _result;
  List<HistoryItem> get history => _history;
  bool get isRadian => _isRadian;

  void setMode(CalculatorMode newMode) {
    _mode = newMode;
    _storageService.saveCalculatorModeIndex(newMode.index);
    if (newMode == CalculatorMode.programmer) {
      _currentBase = 10; 
    }
    clear();
    _shouldClear = false;
    notifyListeners();
  }

  void setBase(int base) {
    _currentBase = base;
    clear();
    notifyListeners();
  }

  void toggleAngleUnit() {
    _isRadian = !_isRadian;
    _storageService.saveIsRadian(_isRadian);
    notifyListeners();
  }

  void append(String val) {
    if (_shouldClear) {
      // Nếu nhập toán tử thì nối tiếp số cũ. Nếu nhập số mới thì xóa số cũ.
      if ('+-×÷%^ LSH RSH AND OR XOR'.contains(val) || val == 'EXP') {
        _shouldClear = false;
      } else {
        _expression = '';
        _shouldClear = false;
      }
    }
    _expression += val;
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '';
    _shouldClear = false;
    notifyListeners();
  }

  void delete() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  void evaluate() {
    if (_expression.isEmpty) return;

    String calculated = '';
    if (_mode == CalculatorMode.programmer) {
      calculated = MathUtil.evaluateProgrammer(_expression, _currentBase);
    } else {
      calculated = MathUtil.evaluateBasicOrScientific(_expression, isRadian: _isRadian);
    }

    _result = calculated;
    
    if (_result != 'Error' && _result.isNotEmpty) {
      _history.insert(0, HistoryItem(expression: _expression, result: _result));
      // Lưu trữ tối đa 50 lịch sử theo yêu cầu đề bài
      if (_history.length > 50) {
        _history.removeLast();
      }
      _storageService.saveHistory(_history);
      
      // Lấy kết quả làm biểu thức mới để cộng dồn liên tục
      _expression = _result; 
      _shouldClear = true;
    }
    
    notifyListeners();
  }

  // Các hàm liên quan tới bộ nhớ tạm (Memory MR, MC, M+, M-)
  void memoryClear() {
    _memoryValue = 0.0;
    _storageService.saveMemoryValue(_memoryValue);
  }

  void memoryRead() {
    if (_memoryValue != 0.0) {
      String memStr = _memoryValue.toString();
      if (memStr.endsWith('.0')) {
        memStr = memStr.substring(0, memStr.length-2);
      }
      append(memStr);
    }
  }

  void memoryAdd() {
    if (_expression.isNotEmpty && _result.isEmpty) evaluate();
    if (_result.isNotEmpty && _result != 'Error') {
      _memoryValue += double.tryParse(_result) ?? 0.0;
      _storageService.saveMemoryValue(_memoryValue);
    }
  }

  void memorySubtract() {
    if (_expression.isNotEmpty && _result.isEmpty) evaluate();
    if (_result.isNotEmpty && _result != 'Error') {
      _memoryValue -= double.tryParse(_result) ?? 0.0;
      _storageService.saveMemoryValue(_memoryValue);
    }
  }
}
