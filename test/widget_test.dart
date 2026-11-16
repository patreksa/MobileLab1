import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1/main.dart';
import 'package:lab1/theme/app_theme.dart';

Future<void> enter(WidgetTester tester, String sequence) async {
  for (final key in sequence.split('')) {
    final button = find.byKey(ValueKey('button_$key'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }
}

String display(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const ValueKey('result'))).data!;

void main() {
  final cases = {
    '12+8=': '20',
    '15−7=': '8',
    '6×7=': '42',
    '20÷4=': '5',
    '5÷0=': 'Ошибка: деление на ноль',
    '12.5+0.5=': '13',
  };
  for (final scenario in cases.entries) {
    testWidgets('Кнопки: ${scenario.key}', (tester) async {
      await tester.pumpWidget(const CalculatorApp());
      await enter(tester, scenario.key);
      expect(display(tester), scenario.value);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Очистка, замена операции и продолжение через UI', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await enter(tester, '12+×2=+1=');
    expect(display(tester), '25');
    await enter(tester, '7');
    expect(display(tester), '7');
    await enter(tester, 'C..5+.5=');
    expect(display(tester), '1');
    await enter(tester, 'C5÷0=');
    expect(display(tester), 'Ошибка: деление на ноль');
    await enter(tester, '2+2=');
    expect(display(tester), '4');
    await enter(tester, 'C');
    expect(display(tester), '0');
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('expression'))).data,
      '',
    );
  });
  testWidgets('Светлая тема, операции фиолетовые, одна кнопка =', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    expect(find.byKey(const ValueKey('button_=')), findsOneWidget);
    for (final label in ['+', '−', '×', '÷']) {
      final button = tester.widget<FilledButton>(
        find.byKey(ValueKey('button_$label')),
      );
      expect(button.style!.backgroundColor!.resolve({}), AppTheme.purple);
    }
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
  });
  for (final size in [
    const Size(320, 568),
    const Size(360, 640),
    const Size(412, 915),
    const Size(640, 360),
  ]) {
    testWidgets('Нет overflow на экране $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CalculatorApp());
      await enter(tester, '123456789012345678901234567890÷0=');
      expect(display(tester), 'Ошибка: деление на ноль');
      expect(tester.takeException(), isNull);
      for (final button in find.byType(FilledButton).evaluate()) {
        final buttonSize = tester.getSize(find.byWidget(button.widget));
        expect(buttonSize.width, greaterThanOrEqualTo(48));
        expect(buttonSize.height, greaterThanOrEqualTo(48));
      }
    });
  }
  testWidgets('Увеличенный системный шрифт', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const CalculatorApp());
    await enter(tester, '12+8=');
    expect(display(tester), '20');
    expect(tester.takeException(), isNull);
  });
}
