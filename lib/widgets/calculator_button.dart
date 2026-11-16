import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOperation = false,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isOperation;
  final bool isSelected;

  String get semanticLabel => switch (label) {
    'C' => 'Очистить',
    '+' => 'Сложить',
    '−' => 'Вычесть',
    '×' => 'Умножить',
    '÷' => 'Разделить',
    '=' => 'Вычислить',
    '.' => 'Десятичная точка',
    _ => label,
  };

  @override
  Widget build(BuildContext context) {
    final isEquals = label == '=';
    final isClear = label == 'C';
    final background = isEquals
        ? AppTheme.equals
        : isOperation
        ? AppTheme.purple
        : isClear
        ? const Color(0xFFEDE5FC)
        : Colors.white;
    return Semantics(
      label: semanticLabel,
      button: true,
      selected: isSelected,
      excludeSemantics: true,
      child: FilledButton(
        key: ValueKey('button_$label'),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: isOperation || isEquals
              ? Colors.white
              : isClear
              ? AppTheme.equals
              : AppTheme.ink,
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(48, 48),
          elevation: isEquals ? 2 : 0,
          shadowColor: AppTheme.purple.withValues(alpha: 0.18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFFD8C4FF)
                  : isOperation || isEquals || isClear
                  ? Colors.transparent
                  : AppTheme.border.withValues(alpha: 0.6),
              width: isSelected ? 3 : 1,
            ),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isEquals ? 38 : 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
