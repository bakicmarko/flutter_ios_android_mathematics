import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OperationType {
  addition(0),
  substraction(1),
  multiplication(2),
  division(3);

  const OperationType(this.ind);
  final int ind;

  static OperationType getEnum(int index) {
    switch (index) {
      case 0:
        return OperationType.addition;
      case 1:
        return OperationType.substraction;
      case 2:
        return OperationType.multiplication;
      default:
        return OperationType.division;
    }
  }

  @override
  String toString() {
    switch (ind) {
      case 0:
        return '+';
      case 1:
        return '-';
      case 2:
        return 'x';
      case 3:
        return '/';
      default:
        return '';
    }
  }
}

class OperationTypeNotifier extends StateNotifier<OperationType> {
  OperationTypeNotifier() : super(OperationType.addition);

  void setOperation(OperationType newOperation) {
    state = newOperation;
  }

  void setOperationByString(String newOperation) {
    // +, -, /, *
    switch (newOperation) {
      case '+':
        state = OperationType.addition;
        break;
      case '-':
        state = OperationType.substraction;
        break;
      case '/':
        state = OperationType.division;
        break;
      case '*':
        state = OperationType.multiplication;
        break;
      default:
        // default to addition
        state = OperationType.addition;
        break;
    }
  }
}

final operationTypeProvider = StateNotifierProvider<OperationTypeNotifier, OperationType>(
  (ref) => OperationTypeNotifier(),
);
