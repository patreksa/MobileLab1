import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
    required this.hasError,
  });

  final String expression;
  final String result;
  final bool hasError;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppTheme.border.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: AppTheme.ink.withValues(alpha: 0.025),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                expression,
                key: const ValueKey('expression'),
                maxLines: 1,
                style: const TextStyle(fontSize: 20, color: AppTheme.secondary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              liveRegion: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  key: const ValueKey('result'),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: hasError ? 24 : 64,
                    height: 1.15,
                    letterSpacing: hasError ? 0 : -2,
                    color: hasError ? AppTheme.equals : AppTheme.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
