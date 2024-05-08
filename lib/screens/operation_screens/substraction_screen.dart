// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/numbers_provider.dart';
import 'package:ict_acc_mathematics/providers/operation_type_provider.dart';
import 'package:ict_acc_mathematics/widgets/numeric_keyboard.dart';

class SubstractionScreen extends ConsumerWidget {
  const SubstractionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(numbersProvider);
    final operation = ref.watch(operationTypeProvider).toString();
    return Center(child: Text('${numbers[0]} $operation ${numbers[1]} = ...'));
  }
}

/*
TextStyle ktextStyle = const TextStyle(
  fontSize: 40,
  fontFeatures: [FontFeature.tabularFigures()],
  height: 1.0,
  letterSpacing: 0.0,
);

const double ktextScaleFactor = 1.0;

class SubstractionScreen extends ConsumerStatefulWidget {
  const SubstractionScreen({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    required this.reset,
  });

  final bool reset;
  final int firstNumber;
  final int secondNumber;
  final String operation = '-';

  @override
  ConsumerState<SubstractionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends ConsumerState<SubstractionScreen> {
  TextEditingController textController = TextEditingController();
  final Duration animationDurationForeground = const Duration(seconds: 1);
  final Duration animationDurationBackground = const Duration(milliseconds: 1);

  Duration animatonDuration = const Duration(seconds: 1);

  int carryOne = 0;
  //0 -  input, 1 - correctAnim , 2 - done correct, 3 - backAnim
  int correctAnimationStart = 0;
  String inputText = '';

  List<Widget> resultWidgetsRow0 = [];
  List<Widget> resultWidgetsRow1 = [];

  bool isDone = false;
  int resultRowPosition = 0;
  int step = 0;
  String resultString = '';
  bool animateEndResult = false;

  void _onNumberPressed(String newText) {
    setState(() {
      inputText = newText;
    });
  }

  void _onAcceptPressed() {
    if (inputText == '') return;

    int number1 = ref.read(numbersProvider.notifier).getFirstNumberDigit(step: step);
    int number2 = ref.read(numbersProvider.notifier).getSecondNumberDigit(step: step);
    if (number1 == -1 && number2 == -1) {
      if (carryOne == 0) {
        setState(() {
          isDone = true;
        });
        //carry == 1
      } else {
        setState(() {
          isDone = true;
          correctAnimationStart = 1;
          carryOne = 0;
        });
      }

      return;
    }
    if (number1 == -1) number1 = 0;
    if (number2 == -1) number2 = 0;

    // log('${number1 - number2 - carryOne}', name: '_onAcceptedPress');

    if (int.parse(inputText) == (number1 - number2 - carryOne)) {
      log('Input is correct', name: '_onAcceptPressed');
      setState(() {
        correctAnimationStart = 1;

        if (step < ref.read(numbersProvider)[0].toString().length) step++;

        if (number1 - number2 - carryOne >= 0) {
          carryOne = 0;
        } else {
          carryOne = 1;
        }
      });

      /// disableKeyboard();
    } else {
      log('Input is wrong!', name: '_onAcceptPressed');
      textController.clear();
    }
  }

  void _reset() {
    setState(() {
      textController.clear();

      carryOne = 0;
      //0 -  input, 1 - correctAnim , 2 - done correct, 3 - backAnim
      correctAnimationStart = 0;
      inputText = '';

      resultWidgetsRow0 = [];
      resultWidgetsRow1 = [];

      isDone = false;
      resultRowPosition = 0;
      step = 0;
      resultString = '';
      animateEndResult = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// _timer.cancel();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reset) _reset();
    final Size screenSize = MediaQuery.of(context).size;
    final double screenOneThirdSize = screenSize.width / 3;
    final double screenTwoThirdSize = screenOneThirdSize * 2;

    final double numberBoxWidth = screenSize.width / 17;
    final double numberBoxHeight = screenSize.height / 20;

    final operation = widget.operation;

    final numbers = ref.watch(numbersProvider);
    final numbersNotifier = ref.read(numbersProvider.notifier);

    final currentFirstTempNum = numbersNotifier.getFirstNumberDigit(step: step);
    final currentSecondTempNum = numbersNotifier.getSecondNumberDigit(step: step);

    final int firstNumber = numbers[0];
    final int secondNumber = numbers[1];

    final int numberOfMaxNumChars =
        (firstNumber >= secondNumber ? firstNumber.toString().length : secondNumber.toString().length);

    String spacings = '';
    if (firstNumber.toString().length > secondNumber.toString().length) {
      spacings += ' ' * (firstNumber.toString().length - secondNumber.toString().length);
    }

    return Column(
      children: [
        const SizedBox(height: 50),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.amber.withOpacity(.3),
                width: screenTwoThirdSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _textInFittedBox(
                      numberBoxWidth,
                      numberBoxHeight,
                      '$firstNumber',
                      backgroundNumberColor: Colors.green.withOpacity(.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _textInFittedBox(
                          numberBoxWidth,
                          numberBoxHeight,
                          operation,
                          backgroundNumberColor: Colors.purple.withOpacity(.3),
                        ),
                        spacings != ''
                            ? _textInFittedBox(
                                numberBoxWidth,
                                numberBoxHeight,
                                spacings,
                                backgroundNumberColor: Colors.lime.withOpacity(.3),
                              )
                            : Container(),
                        _textInFittedBox(
                          numberBoxWidth,
                          numberBoxHeight,
                          '$secondNumber',
                          backgroundNumberColor: Colors.red.withOpacity(.3),
                        ),
                      ],
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
                    width: numberBoxWidth * (numberOfMaxNumChars + 1),
                  ),
                ),
              ),
              Container(
                height: screenSize.height / 3,
                color: Colors.brown.withOpacity(.3),
                child: Stack(
                  children: [
                    ...resultWidgetsRow0,
                    ...resultWidgetsRow1,
                    Positioned(
                      top: (screenSize.height / 3) / 3,
                      left: 0,
                      child: _textInFittedBox(
                        numberBoxWidth,
                        numberBoxHeight,
                        isDone
                            ? ''
                            : '${currentFirstTempNum.toString()}$operation${currentSecondTempNum.toString()}${carryOne == 1 ? '-1' : ''}=',
                        backgroundNumberColor: Colors.brown.withOpacity(.3),
                      ),
                    ),
                    AnimatedPositioned(
                      top: [1, 2].contains(correctAnimationStart) ? 50 : (screenSize.height / 3) / 3,
                      right: [1, 2].contains(correctAnimationStart)
                          ? screenOneThirdSize + numberBoxWidth * resultRowPosition
                          : screenSize.width - numberBoxWidth * (4 + inputText.length + carryOne * 2),
                      duration: animatonDuration,
                      child: _textInFittedBox(numberBoxWidth, numberBoxHeight, inputText,
                          backgroundNumberColor: Colors.amber),
                      onEnd: () => {
                        setState(
                          () {
                            if (correctAnimationStart == 3) {
                              if (isDone) {
                                correctAnimationStart = -1;
                                resultWidgetsRow0 = [];
                                resultWidgetsRow1 = [
                                  Positioned(
                                    top: numberBoxHeight,
                                    right: screenOneThirdSize,
                                    child: _textInFittedBox(numberBoxWidth, numberBoxHeight, resultString,
                                        textColor: !animateEndResult ? Colors.green : Colors.black),
                                  ),
                                ];
                                //startTimer();
                              } else {
                                animatonDuration = animationDurationForeground;
                                correctAnimationStart = 0;
                              }
                            }
                            if (correctAnimationStart == 1) {
                              animatonDuration = animationDurationBackground;
                              correctAnimationStart = 2;
                            }

                            if (correctAnimationStart == 2) {
                              if (inputText.length > 1) {
                                carryOne = 1;
                                resultWidgetsRow0.add(
                                  Positioned(
                                    top: 0,
                                    right: screenOneThirdSize + numberBoxWidth * (resultRowPosition + 1),
                                    child: _textInFittedBox(numberBoxWidth, numberBoxHeight, '1',
                                        backgroundNumberColor: Colors.red),
                                  ),
                                );
                                resultString = inputText[1] + resultString;
                                resultWidgetsRow1.add(
                                  Positioned(
                                    top: numberBoxHeight,
                                    right: screenOneThirdSize + numberBoxWidth * resultRowPosition,
                                    child: _textInFittedBox(numberBoxWidth, numberBoxHeight, inputText[1]),
                                  ),
                                );
                              } else {
                                resultString = inputText + resultString;
                                resultWidgetsRow1.add(
                                  Positioned(
                                    top: numberBoxHeight,
                                    right: screenOneThirdSize + numberBoxWidth * resultRowPosition,
                                    child: _textInFittedBox(numberBoxWidth, numberBoxHeight, inputText),
                                  ),
                                );
                              }
                              resultRowPosition++;
                              inputText = '';
                              textController.clear();
                              correctAnimationStart = 3;
                            }
                          },
                        ),
                        // Call the function after 3 seconds
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: IgnorePointer(
            ignoring: correctAnimationStart != 0,
            child: NumericKeypad(
                controller: textController, onNumberPressed: _onNumberPressed, onAcceptPressed: _onAcceptPressed),
          ),
        ),
      ],
    );
  }
}

Widget _textInFittedBox(double width, double height, String text, {Color? backgroundNumberColor, Color? textColor}) {
  if (text == '') return Container();
  if (text.startsWith('-1--1')) text = '    1=';
  text = text.replaceAll(RegExp(r'\-\-1'), '');

  return Container(
    color: backgroundNumberColor,
    width: width * text.length * ktextScaleFactor,
    height: height * ktextScaleFactor,
    child: FittedBox(
      alignment: Alignment.centerRight,
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: textColor != null
            ? ktextStyle.copyWith(wordSpacing: width, color: textColor)
            : ktextStyle.copyWith(wordSpacing: width),
      ),
    ),
  );
}
*/