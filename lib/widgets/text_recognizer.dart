import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageTextRecognizer {
  late TextRecognizer recognizer;

  ImageTextRecognizer() {
    recognizer = TextRecognizer();
  }

  void dispose() {
    recognizer.close();
  }

  Future<List<dynamic>> processImageFromFile(File file) async {
    final image = InputImage.fromFile(file);
    final recognized = await recognizer.processImage(image);
    return findEquation(recognized.text);
    //return recognized.text;
  }

  List<dynamic> findEquation(String input) {
    List<dynamic> resultNumbers = List<dynamic>.filled(3, null);
    log('finding...');
    // every string represents one char

    // find non numeric characthers
    RegExp regexNonNumericLeadingAndTrailing = RegExp(r'^[^0-9]+|[^0-9]+$');
    // find numeric and non numeric values
    RegExp regexSeparateNumericAndNonNumeric = RegExp(r'\D+|\d+');

    RegExp regexSpaces = RegExp(r'\s+');

    List<String> lines = input.split('\n');

    log('input:');
    log(input);
    log('lines:');
    log(lines.toString());
    List<List<String>> possibleInputs = [];
    for (String line in lines) {
      // remove leading and trailing non numeric characters
      line = line.replaceAll(regexNonNumericLeadingAndTrailing, '');
      // remove spaces
      line = line.replaceAll(regexSpaces, '');
      List<String> tmpList =
          regexSeparateNumericAndNonNumeric.allMatches(line).map((match) => match.group(0) ?? '?').toList();
      if (tmpList.length >= 3) {
        possibleInputs.add(tmpList);
      }
    }
    log(possibleInputs.toString());

    int? firstNumber;
    //String? operator;
    int? secondNumber;
    for (int i = 0; i < possibleInputs.length; i++) {
      List<String> currentList = possibleInputs[i];
      if (currentList.length < 3) break;
      try {
        //
        firstNumber = int.parse(currentList[0]);
        secondNumber = int.parse(currentList[2]);
      } catch (e) {
        log(e.toString());
      }
      if (firstNumber != null && secondNumber != null) {
        log('firstNum: $firstNumber, secondNum: $secondNumber');
        resultNumbers[0] = firstNumber;
        resultNumbers[2] = secondNumber;
        if (currentList[1].contains('+') || currentList[1].contains('t')) {
          resultNumbers[1] = '+';
          break;
        } else if (currentList[1].contains('-') || currentList[1].contains('_')) {
          resultNumbers[1] = '-';
          break;
        } else if (currentList[1].contains(':') || currentList[1].contains('/') || currentList[1].contains('%')) {
          resultNumbers[1] = '/';
          break;
        } else if (currentList[1].contains('x') || currentList[1].contains('*') || currentList[1].contains('.')) {
          resultNumbers[1] = '*';
          break;
        }
      }
    }
    // default to multiplication (hardest to detect)
    if (resultNumbers[1] == null) resultNumbers[1] = '*';
    log('finished search...');
    return resultNumbers;
  }

  //------------------- other

  Future<String> processImageFromImageString(String imgPath) async {
    final image = InputImage.fromFile(File(imgPath));
    final recognized = await recognizer.processImage(image);
    findEquation(recognized.text);
    return recognized.text;
  }

  Future<String> processImageBytes(Uint8List bytes) async {
    // not implemented correctlly
    final image = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
          size: const Size(100, 100),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: 100),
    );
    final recognized = await recognizer.processImage(image);
    return recognized.text;
  }
}
