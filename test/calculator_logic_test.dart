import 'package:flutter_test/flutter_test.dart';
import 'package:lab1/logic/calculator_logic.dart';
import 'package:lab1/state/calculator_state.dart';

void main() {
  final logic = CalculatorLogic();
  final cases = <(double, String, double, String)>[
    (12, '+', 8, '20'),
    (15, '−', 7, '8'),
    (6, '×', 7, '42'),
    (20, '÷', 4, '5'),
    (12.5, '+', 0.5, '13'),
    (0.1, '+', 0.2, '0.3'),
    (1, '÷', 3, '0.333333333333'),
    (2, '−', 5, '-3'),
  ];
  for (final (first, operation, second, expected) in cases) {
    test('$first $operation $second = $expected', () {
      expect(
        logic.formatResult(logic.calculate(first, operation, second)),
        expected,
      );
    });
  }
  test('Деление на ноль сообщает точную причину', () {
    expect(
      () => logic.calculate(5, '÷', 0),
      throwsA(
        isA<CalculatorException>().having(
          (error) => error.message,
          'message',
          'Ошибка: деление на ноль',
        ),
      ),
    );
  });
  test('Некорректные операции и числа отклоняются', () {
    expect(
      () => logic.calculate(1, '?', 2),
      throwsA(isA<CalculatorException>()),
    );
    for (final input in ['', 'abc', '1.2.3', 'NaN', 'Infinity']) {
      expect(
        () => logic.parseNumber(input),
        throwsA(isA<CalculatorException>()),
      );
    }
    expect(
      () => logic.calculate(double.maxFinite, '×', 2),
      throwsA(isA<CalculatorException>()),
    );
    expect(
      () => logic.formatResult(double.nan),
      throwsA(isA<CalculatorException>()),
    );
    expect(logic.formatResult(-0.0), '0');
    expect(logic.formatResult(1e-20), '1e-20');
    expect(logic.formatResult(1e20), '100000000000000000000');
  });

  CalculatorState enter(String sequence) {
    final state = CalculatorState();
    for (final key in sequence.split('')) {
      state.press(key);
    }
    return state;
  }

  group('CalculatorState', () {
    test('Очистка сбрасывает все поля', () {
      final state = enter('12+8=C');
      expect(state.display, '0');
      expect(state.expression, '');
      expect(state.firstOperand, isNull);
      expect(state.result, isNull);
      expect(state.operation, isNull);
      expect(state.hasError, isFalse);
    });
    test('Повторная операция заменяет предыдущую', () {
      final state = enter('12+×2=');
      expect(state.display, '24');
      expect(state.expression, '12 × 2');
    });
    test('Результат используется в следующем вычислении', () {
      expect(enter('12+8=×2=').display, '40');
      expect(enter('12+8×2=').display, '40');
      expect(enter('1÷3=×3=').display, '1');
    });
    test('Цифра после результата начинает новое выражение', () {
      final state = enter('12+8=7');
      expect(state.display, '7');
      expect(state.expression, '7');
      expect(state.operation, isNull);
    });
    test('Точка, ведущие нули и повторные точки', () {
      expect(enter('..5+.5=').display, '1');
      expect(enter('00012.5.0').display, '12.50');
      expect(enter('12.+.5=').display, '12.5');
      expect(enter('2+3=.').display, '0.');
    });
    test('Выражение обновляется во время ввода', () {
      final state = enter('12+8');
      expect(state.expression, '12 + 8');
      state.press('=');
      expect(state.expression, '12 + 8');
      expect(state.display, '20');
      state.press('=');
      expect(state.display, '20');
    });
    test('Ошибка и восстановление после неё', () {
      final state = enter('5÷0=');
      expect(state.display, 'Ошибка: деление на ноль');
      expect(state.hasError, isTrue);
      state.press('2');
      state.press('+');
      state.press('3');
      state.press('=');
      expect(state.display, '5');
      expect(state.hasError, isFalse);
      state.press('?');
      expect(state.hasError, isTrue);
      state.press('C');
      expect(state.display, '0');
    });
    test('Неполное выражение обрабатывается', () {
      expect(enter('12+=').display, 'Ошибка: введите второе число');
      expect(enter('12=').display, '12');
    });
  });
}
