// ignore_for_file: unused_import

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/numbers_provider.dart';
import 'package:ict_acc_mathematics/providers/operation_type_provider.dart';
import 'package:ict_acc_mathematics/util/convert_util.dart';
import 'package:ict_acc_mathematics/widgets/numeric_keyboard.dart';

class MultiplicationScreen extends ConsumerWidget {
  const MultiplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(numbersProvider);
    final operation = ref.watch(operationTypeProvider).toString();
    return Center(child: Text('${numbers[0]} $operation ${numbers[1]} = ...'));
  }
}

/*
class MultiplicationScreen extends StatefulWidget {
  const MultiplicationScreen({super.key, required this.firstNumber, required this.secondNumber});

  final int firstNumber;
  final int secondNumber;
  final String operation = 'x';

  @override
  State<MultiplicationScreen> createState() => _MultiplicationScreenState();
}

class _MultiplicationScreenState extends State<MultiplicationScreen> {
  BoxDecoration boxDecoration = BoxDecoration(border: Border.all(color: Colors.black, width: 1));
  TextStyle textStyle = const TextStyle(fontSize: 40, fontFeatures: [FontFeature.tabularFigures()]);

  TextEditingController textController = TextEditingController();
  bool isDone = false;
  bool firstMove = false;
  String inputText = '';
  late int firstNCurrentDigit, secondNCurrentDigit;
  late List<int> firstNList, secondNList;

  void _onNumberPressed(String newText) {
    setState(() {
      inputText = newText;
    });
  }

  void _onAcceptPressed() {
    /// if (inputText == '') return;
    /// if (int.parse(inputText) == (firstNCurrentDigit + secondNCurrentDigit)) {
    ///   log('Input is correct');
    ///   setState(() {
    ///     firstMove = true;
    ///   });
    /// } else {
    ///   log('Input is wrong!');
    ///   textController.clear();
    /// }
    log('divide');
  }

  void setNextDigits() {
    //currentFirstTempNum, currentSecondTempNum
    //
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    //final double screenOneThirdSize = screenWidth / 3;
    final double screenTwoThirdSize = screenWidth * 2 / 3;
    final operation = widget.operation;
    const double textCharacterWidth = 19.6;
    final int firstNumber = widget.firstNumber;
    final int secondNumber = widget.secondNumber;

    final List<int> firstNumberList = intToListInt(firstNumber);
    final List<int> secondNumberList = intToListInt(secondNumber);
    final currentFirstTempNum = firstNumberList.last;
    final currentSecondTempNum = secondNumberList.last;
    firstNCurrentDigit = currentFirstTempNum;
    secondNCurrentDigit = currentSecondTempNum;
    firstNList = firstNumberList;
    secondNList = secondNumberList;

    // ignore: unused_local_variable
    final int numberOfMaxNumChars =
        (firstNumber >= secondNumber ? firstNumber.toString().length : secondNumber.toString().length);

    return Column(
      children: [
        Center(
          child: Text('$firstNumber $operation $secondNumber = ...', style: textStyle),
        ),
        const SizedBox(height: 50),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.amber.withOpacity(.3),
                width: screenTwoThirdSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.green.withOpacity(.3),
                      child: Text('$firstNumber ', style: textStyle),
                    ),
                    Container(
                      color: Colors.red.withOpacity(.3),
                      child: Text(operation, style: textStyle),
                    ),
                    Container(
                      color: Colors.green.withOpacity(.3),
                      child: Text(' $secondNumber', style: textStyle),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.red.withOpacity(.3),
                width: screenTwoThirdSize,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      color: Colors.black.withOpacity(.7),
                      height: 2,
                      width: textCharacterWidth * ((firstNumberList.length + secondNumberList.length) + 3)),
                ),
              ),
              Container(
                height: textStyle.fontSize! * 4,
                width: double.infinity,
                color: Colors.brown.withOpacity(.3),
                child: Container(
                  color: Colors.blue.withOpacity(.3),
                  width: screenTwoThirdSize,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 300,
                        child: Container(
                          color: Colors.amber.withOpacity(.3),
                          width: 100,
                          height: 100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: NumericKeypad(
              controller: textController, onNumberPressed: _onNumberPressed, onAcceptPressed: _onAcceptPressed),
        ),

        /// ElevatedButton(
        ///   onPressed: () => {
        ///     setState(() {
        ///       firstMove = !firstMove;
        ///       log(firstMove.toString());
        ///     })
        ///   },
        ///   child: const Text('changemove'),
        /// )
      ],
    );
  }
}
*/