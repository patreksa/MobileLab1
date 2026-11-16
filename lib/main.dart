import 'package:flutter/material.dart';

import 'screens/calculator_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Калькулятор',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const CalculatorScreen(),
  );
}
