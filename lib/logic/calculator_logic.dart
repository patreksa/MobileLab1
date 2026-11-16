/// Арифметика и форматирование без зависимости от Flutter.
class CalculatorLogic {
  static const operations = ['+', '−', '×', '÷'];

  double parseNumber(String input) {
    final value = double.tryParse(input);
    if (value == null || !value.isFinite) {
      throw const CalculatorException('Ошибка: некорректное число');
    }
    return value;
  }

  double calculate(double first, String operation, double second) {
    if (!first.isFinite || !second.isFinite) {
      throw const CalculatorException('Ошибка: некорректное число');
    }
    if (operation == '÷' && second == 0) {
      throw const CalculatorException('Ошибка: деление на ноль');
    }
    final result = switch (operation) {
      '+' => first + second,
      '−' => first - second,
      '×' => first * second,
      '÷' => first / second,
      _ => throw const CalculatorException('Ошибка: неизвестная операция'),
    };
    if (!result.isFinite) {
      throw const CalculatorException('Ошибка: результат слишком велик');
    }
    return result;
  }

  /// 12 значащих цифр скрывают хвосты double, например 0.1 + 0.2.
  /// Для продолжения вычислений состояние хранит исходный double.
  String formatResult(double value) {
    if (!value.isFinite) {
      throw const CalculatorException('Ошибка: некорректный результат');
    }
    if (value == 0) return '0';
    final text = double.parse(value.toStringAsPrecision(12)).toString();
    final parts = text.split('e');
    final mantissa = parts.first.replaceFirst(RegExp(r'\.0$'), '');
    return parts.length == 1 ? mantissa : '${mantissa}e${parts[1]}';
  }
}

class CalculatorException implements Exception {
  const CalculatorException(this.message);
  final String message;

  @override
  String toString() => message;
}
