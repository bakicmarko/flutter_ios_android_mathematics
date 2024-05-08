import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumbersProvider extends StateNotifier<List<int>> {
  // number1, number2
  NumbersProvider()
      : super(
          [
            // 100 -999
            Random().nextInt(900) + 100,
            Random().nextInt(900) + 100,
          ],
        );

  void setNumbers(List<int> newNums) {
    state = newNums;
  }

  void generateNewNumbers(int firstDigitsCount, int secondDigitsCount, {bool isSubstraction = false}) {
    // 1: 0 - 9       10 + 0
    // 2: 10 - 99     90 + 10
    // 3: 100 - 999   900 + 100

    int minFirst = 0;
    int maxFirst = 10;
    if (firstDigitsCount != 1) {
      minFirst = pow(10, firstDigitsCount - 1).toInt();
      maxFirst = 9 * pow(10, firstDigitsCount - 1).toInt();
    }

    int minSecond = 0;
    int maxSecond = 10;
    if (secondDigitsCount != 1) {
      minSecond = pow(10, secondDigitsCount - 1).toInt();
      maxSecond = 9 * pow(10, secondDigitsCount - 1).toInt();
    }

    int first = Random().nextInt(maxFirst) + minFirst;
    int second = Random().nextInt(maxSecond) + minSecond;

    if (isSubstraction && first < second) {
      dev.log('Swapping numbers...', name: 'generateNewNumbers');
      int tempF = first;
      first = second;
      second = tempF;
    }

    state[0] = first;
    state[1] = second;
  }

  int getFirstNumberDigit({required int step}) {
    if (step > state[0].toString().length - 1) return -1;
    return int.parse(state[0].toString()[state[0].toString().length - 1 - step]);
  }

  int getSecondNumberDigit({required int step}) {
    if (step > state[1].toString().length - 1) return -1;
    return int.parse(state[1].toString()[state[1].toString().length - 1 - step]);
  }
}

final numbersProvider = StateNotifierProvider<NumbersProvider, List<int>>(
  ((ref) => NumbersProvider()),
);
