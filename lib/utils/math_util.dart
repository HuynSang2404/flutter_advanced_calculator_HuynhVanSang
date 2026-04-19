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
          .replaceAll('π', 'pi')
          .replaceAll('e', '2.718281828459045')
          .replaceAll('EXP', '*10^');

      if (!isRadian) {
        exprStr = exprStr.replaceAll('sin(', 'sin((pi/180)*');
        exprStr = exprStr.replaceAll('cos(', 'cos((pi/180)*');
        exprStr = exprStr.replaceAll('tan(', 'tan((pi/180)*');
      }

      // Tối ưu UX: Tự động đóng ngoặc đằng sau nếu người dùng quên (vd: sin(45 )
      int leftParens = exprStr.split('(').length - 1;
      int rightParens = exprStr.split(')').length - 1;
      while (leftParens > rightParens) {
        exprStr += ')';
        rightParens++;
      }

      // ignore: deprecated_member_use
      Parser p = Parser();
      Expression exp = p.parse(exprStr);

      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Xử lý lỗi chia cho 0
      if (eval.isInfinite || eval.isNaN) {
        return 'Error';
      }

      // Xóa phần thập phân .0 nếu là số nguyên
      String result = eval.toString();
      if (result.endsWith('.0')) {
        return result.substring(0, result.length - 2);
      }
      return result;
    } catch (e) {
      return 'Error';
    }
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
