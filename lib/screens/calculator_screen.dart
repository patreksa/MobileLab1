import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../logic/calculator_logic.dart';
import '../state/calculator_state.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _calculator = CalculatorState();

  Widget _button(String label) => CalculatorButton(
    label: label,
    isOperation: CalculatorLogic.operations.contains(label),
    isSelected: _calculator.operation == label,
    onPressed: () => setState(() => _calculator.press(label)),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Прокрутка на низких экранах сохраняет удобную высоту кнопок.
          final height = math.max(constraints.maxHeight, 660.0);
          return SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 4,
                          child: CalculatorDisplay(
                            expression: _calculator.expression,
                            result: _calculator.display,
                            hasError: _calculator.hasError,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(flex: 7, child: _keypad()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _row(List<String> labels) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < labels.length; i++) ...[
        if (i > 0) const SizedBox(width: 12),
        Expanded(child: _button(labels[i])),
      ],
    ],
  );

  Widget _keypad() => LayoutBuilder(
    builder: (context, constraints) {
      // Размер каждой ячейки одинаков: = занимает три строки и два зазора.
      final cell = (constraints.maxHeight - 48) / 5;
      return Column(
        children: [
          SizedBox(height: cell, child: _row(['C', '÷', '×', '−'])),
          const SizedBox(height: 12),
          SizedBox(height: cell, child: _row(['7', '8', '9', '+'])),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, lower) {
                final width = (lower.maxWidth - 36) / 4;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: width * 3 + 24,
                      child: Column(
                        children: [
                          Expanded(child: _row(['4', '5', '6'])),
                          const SizedBox(height: 12),
                          Expanded(child: _row(['1', '2', '3'])),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: width * 2 + 12,
                                  child: _button('0'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: _button('.')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _button('=')),
                  ],
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
