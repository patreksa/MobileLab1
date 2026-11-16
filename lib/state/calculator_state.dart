import '../logic/calculator_logic.dart';

class CalculatorState {
  CalculatorState({CalculatorLogic? logic})
    : _logic = logic ?? CalculatorLogic();

  final CalculatorLogic _logic;
  String _currentNumber = '0';
  double? _firstOperand;
  double? _result;
  String? _operation;
  String _expression = '';
  String? _error;
  bool _waitingForOperand = false;
  bool _finished = false;

  String get currentNumber => _currentNumber;
  double? get firstOperand => _firstOperand;
  double? get result => _result;
  String? get operation => _operation;
  String get expression => _expression;
  bool get hasError => _error != null;
  String get display => _error ?? _currentNumber;

  void clear() {
    _currentNumber = '0';
    _firstOperand = null;
    _result = null;
    _operation = null;
    _expression = '';
    _error = null;
    _waitingForOperand = false;
    _finished = false;
  }

  void press(String key) {
    if (key == 'C') {
      clear();
      return;
    }
    try {
      if (RegExp(r'^[0-9.]$').hasMatch(key)) {
        _input(key);
      } else if (CalculatorLogic.operations.contains(key)) {
        if (!hasError) _selectOperation(key);
      } else if (key == '=') {
        if (!hasError) _equals();
      } else {
        throw const CalculatorException('Ошибка: некорректный ввод');
      }
    } on CalculatorException catch (error) {
      _error = error.message;
    }
  }

  void _input(String key) {
    if (hasError || _finished) clear();
    if (_waitingForOperand) {
      _currentNumber = '0';
      _waitingForOperand = false;
    }
    if (key == '.') {
      if (!_currentNumber.contains('.')) _currentNumber += '.';
    } else {
      _currentNumber = _currentNumber == '0' ? key : _currentNumber + key;
    }
    _updateExpression();
  }

  void _selectOperation(String key) {
    if (_operation != null && !_waitingForOperand) {
      _evaluate();
    } else if (_operation == null) {
      _firstOperand = _finished && _result != null
          ? _result
          : _logic.parseNumber(_currentNumber);
    }
    _operation = key;
    _finished = false;
    _waitingForOperand = true;
    _updateExpression();
  }

  void _equals() {
    if (_finished) return;
    if (_operation == null) {
      _result = _logic.parseNumber(_currentNumber);
      _expression = _currentNumber;
      _currentNumber = _logic.formatResult(_result!);
    } else {
      if (_waitingForOperand) {
        throw const CalculatorException('Ошибка: введите второе число');
      }
      _evaluate();
    }
    _operation = null;
    _waitingForOperand = false;
    _finished = true;
  }

  void _evaluate() {
    final value = _logic.calculate(
      _firstOperand!,
      _operation!,
      _logic.parseNumber(_currentNumber),
    );
    _result = value;
    _firstOperand = value;
    _currentNumber = _logic.formatResult(value);
  }

  void _updateExpression() {
    _expression = _operation == null
        ? _currentNumber
        : '${_logic.formatResult(_firstOperand!)} $_operation'
              '${_waitingForOperand ? '' : ' $_currentNumber'}';
  }
}
