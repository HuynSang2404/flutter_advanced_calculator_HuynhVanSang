import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class MathUtil {
  // Xử lý biểu thức toán học cơ bản và khoa học
  static String evaluateBasicOrScientific(String expression, {bool isRadian = true}) {
    try {
      // Chuyển ký hiệu hiển thị sang ký hiệu của thư viện
      String exprStr = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '${math.pi}')
          .replaceAll('EXP', '*10^');

      // Xử lý hàm sqrt
      exprStr = exprStr.replaceAll('sqrt(', 'sqrt(');
      
      // Xử lý log10 - chuyển log(x) thành ln(x)/ln(10)
      exprStr = _convertLog10ToLn(exprStr);

      // Chuyển đổi độ sang radian nếu đang ở chế độ độ (degrees)
      if (!isRadian) {
        // Tìm và chuyển đổi các hàm lượng giác
        exprStr = _convertDegreesToRadians(exprStr);
      }

      // Tối ưu UX: Tự động đóng ngoặc đằng sau nếu người dùng quên (vd: sin(45 )
      int leftParens = exprStr.split('(').length - 1;
      int rightParens = exprStr.split(')').length - 1;
      while (leftParens > rightParens) {
        exprStr += ')';
        rightParens++;
      }

      Parser p = Parser();
      Expression exp = p.parse(exprStr);

      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Xử lý lỗi chia cho 0
      if (eval.isInfinite || eval.isNaN) {
        return 'Error';
      }

      // Làm tròn để tránh lỗi floating point
      if ((eval - eval.roundToDouble()).abs() < 1e-10) {
        eval = eval.roundToDouble();
      }

      // Xóa phần thập phân .0 nếu là số nguyên
      String result = eval.toString();
      if (result.endsWith('.0')) {
        return result.substring(0, result.length - 2);
      }
      
      // Làm tròn đến 10 chữ số thập phân
      if (result.contains('.') && result.split('.')[1].length > 10) {
        result = eval.toStringAsFixed(10);
        // Xóa các số 0 thừa ở cuối
        result = result.replaceAll(RegExp(r'0+$'), '');
        if (result.endsWith('.')) {
          result = result.substring(0, result.length - 1);
        }
      }
      
      return result;
    } catch (e) {
      return 'Error';
    }
  }

  // Chuyển đổi log10 sang ln
  static String _convertLog10ToLn(String expr) {
    int index = 0;
    while (index < expr.length) {
      int logIndex = expr.indexOf('log(', index);
      if (logIndex == -1) break;
      
      // Tìm ngoặc đóng tương ứng
      int openParen = logIndex + 3; // 'log' has 3 characters
      int closeParen = _findMatchingParen(expr, openParen);
      
      if (closeParen != -1) {
        String innerExpr = expr.substring(openParen + 1, closeParen);
        // log10(x) = ln(x) / ln(10)
        String converted = '(ln($innerExpr)/ln(10))';
        expr = expr.substring(0, logIndex) + converted + expr.substring(closeParen + 1);
        index = logIndex + converted.length;
      } else {
        break;
      }
    }
    
    return expr;
  }

  // Chuyển đổi các hàm lượng giác từ độ sang radian
  static String _convertDegreesToRadians(String expr) {
    // Xử lý sin, cos, tan với độ
    final trigFunctions = ['sin', 'cos', 'tan'];
    
    for (var func in trigFunctions) {
      int index = 0;
      while (index < expr.length) {
        int funcIndex = expr.indexOf('$func(', index);
        if (funcIndex == -1) break;
        
        // Tìm ngoặc đóng tương ứng
        int openParen = funcIndex + func.length;
        int closeParen = _findMatchingParen(expr, openParen);
        
        if (closeParen != -1) {
          String innerExpr = expr.substring(openParen + 1, closeParen);
          String converted = '$func(($innerExpr)*${math.pi}/180)';
          expr = expr.substring(0, funcIndex) + converted + expr.substring(closeParen + 1);
          index = funcIndex + converted.length;
        } else {
          break;
        }
      }
    }
    
    return expr;
  }

  // Tìm ngoặc đóng tương ứng
  static int _findMatchingParen(String expr, int openIndex) {
    int count = 1;
    for (int i = openIndex + 1; i < expr.length; i++) {
      if (expr[i] == '(') count++;
      if (expr[i] == ')') {
        count--;
        if (count == 0) return i;
      }
    }
    return -1;
  }

  // Chế độ dành cho lập trình viên (Programmer Mode)
  static String evaluateProgrammer(String expression, int base) {
    try {
      String exprStr = expression.replaceAll('×', '*').replaceAll('÷', '/');
      
      // Xử lý phép toán Bitwise riêng biệt
      if (exprStr.contains('AND') || exprStr.contains('OR') || exprStr.contains('XOR') || exprStr.contains('LSH') || exprStr.contains('RSH')) {
        return _evaluateBitwise(exprStr, base);
      }

      // Đưa về hệ cơ số 10 để tính toán
      RegExp numRegex;
      if (base == 16) {
        numRegex = RegExp(r'[0-9A-Fa-f]+');
      } else if (base == 2) {
        numRegex = RegExp(r'[01]+');
      } else {
        numRegex = RegExp(r'\d+');
      }

      String decExpr = exprStr;
      if (base != 10) {
        decExpr = exprStr.replaceAllMapped(numRegex, (match) {
          int val = int.parse(match.group(0)!, radix: base);
          return val.toString();
        });
      }

      Parser p = Parser();
      Expression exp = p.parse(decExpr);
      double eval = exp.evaluate(EvaluationType.REAL, ContextModel());

      if (eval.isInfinite || eval.isNaN) return 'Error';

      int intVal = eval.toInt();
      return _formatByBase(intVal, base);
    } catch (e) {
      return 'Error';
    }
  }

  // Thuật toán tính nhanh phép toán Bitwise
  static String _evaluateBitwise(String expr, int base) {
     List<String> tokens = expr.split(' ');
     if (tokens.length >= 3) {
       int val1 = int.parse(tokens[0], radix: base);
       String op = tokens[1];
       int val2 = int.parse(tokens[2], radix: base);
       int res = 0;
       
       switch(op) {
         case 'AND': res = val1 & val2; break;
         case 'OR': res = val1 | val2; break;
         case 'XOR': res = val1 ^ val2; break;
         case 'LSH': res = val1 << val2; break;
         case 'RSH': res = val1 >> val2; break;
       }
       return _formatByBase(res, base);
     }
     return 'Error';
  }

  // Format trả lại định dạng hiển thị hệ cơ số
  static String _formatByBase(int value, int base) {
    if (base == 16) {
      return value.toRadixString(16).toUpperCase();
    } else if (base == 2) {
      return value.toRadixString(2);
    } else if (base == 8) {
      return value.toRadixString(8);
    }
    return value.toString();
  }
}
