import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/camera_provider.dart';
import 'package:ict_acc_mathematics/providers/camera_reading_provider.dart';
import 'package:ict_acc_mathematics/providers/numbers_provider.dart';
import 'package:ict_acc_mathematics/providers/operation_type_provider.dart';
import 'package:ict_acc_mathematics/widgets/text_recognizer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final ImageTextRecognizer _recognizer = ImageTextRecognizer();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      ref.read(cameraProvider)!,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _recognizer.dispose();
  }

  void setNumbers(List<int> numbers, Uint8List imgBytes) {
    ref.read(numbersProvider.notifier).setNumbers(numbers);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          imageBytes: imgBytes,
        ),
      ),
    );
  }

  void invalidReadFromImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${AppLocalizations.of(context)!.invalidReading}!'),
          content: Text('${AppLocalizations.of(context)!.pleaseTryAgain}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  void setOperationType(String operation) {
    ref.read(operationTypeProvider.notifier).setOperationByString(operation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.takePicutre)),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(children: [
              Center(child: CameraPreview(_controller)),
              /*
              Center(
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                ),
              )
              */
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;
            // If the picture was taken, display it on a new screen.
            CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              compressQuality: 100,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              uiSettings: [
                AndroidUiSettings(
                  toolbarTitle: AppLocalizations.of(context)!.cropImage,
                  toolbarColor: Theme.of(context).colorScheme.secondary,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false,
                  showCropGrid: false,
                  hideBottomControls: false,
                ),
                IOSUiSettings(
                  title: AppLocalizations.of(context)!.cropImage,
                ),
                WebUiSettings(
                  context: context,
                ),
              ],
            );
            if (croppedFile == null) return;

            Uint8List bytes = await croppedFile.readAsBytes();

            var rng = math.Random();
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file = File('$tempPath${rng.nextInt(100000)}.jpg');

            await file.writeAsBytes(bytes);

            // File croppedImageFile = File.fromRawPath(bytes);

            List<dynamic> recognizedItems = await _recognizer.processImageFromFile(file);
            if (recognizedItems[0] != null && recognizedItems[2] != null) {
              if (recognizedItems[1] != null) setOperationType(recognizedItems[1]);
              setNumbers([recognizedItems[0]!, recognizedItems[2]!], bytes);
            } else {
              invalidReadFromImage();
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            // ignore: avoid_print
            log('error: taking/processing image ', name: 'camera_screen.CameraScreen.FloatingActionButton.onPressed');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends ConsumerStatefulWidget {
  final Uint8List imageBytes;

  const DisplayPictureScreen({super.key, required this.imageBytes});

  @override
  ConsumerState<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends ConsumerState<DisplayPictureScreen> {
  late TextEditingController _firstNumberController;
  late TextEditingController _secondNumberController;

  OperationType _choosenOperation = OperationType.addition;

  @override
  void initState() {
    super.initState();
    _firstNumberController = TextEditingController();
    _secondNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNumberController.dispose();
    _secondNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detectedNumbers = ref.watch(numbersProvider);
    final currentOperation = ref.watch(operationTypeProvider);
    _firstNumberController.text = detectedNumbers[0].toString();
    _secondNumberController.text = detectedNumbers[1].toString();
    _choosenOperation = currentOperation;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.result)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Image.memory(widget.imageBytes),
          ),
          Column(children: [
            Text('${AppLocalizations.of(context)!.detectedEquation}:'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    controller: _firstNumberController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.first,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                DropdownMenu<OperationType>(
                  initialSelection: currentOperation,
                  enableSearch: false,
                  width: 90,
                  dropdownMenuEntries: [
                    OperationType.addition,
                    OperationType.substraction,
                    OperationType.division,
                    OperationType.multiplication
                  ]
                      .map(
                        (entry) => DropdownMenuEntry(
                          value: entry,
                          label: entry.toString(),
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    if (value != null) {
                      _choosenOperation = value;
                    }
                  },
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    controller: _secondNumberController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.second,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ]),
          // add dropdownitems
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    try {
                      ref.read(numbersProvider.notifier).setNumbers([
                        int.parse(_firstNumberController.text),
                        int.parse(_secondNumberController.text),
                      ]);
                    } catch (e) {
                      // ignore
                    }

                    // +, -, /, *
                    ref.read(operationTypeProvider.notifier).setOperation(_choosenOperation);
                    ref.read(cameraReadingProvider.notifier).setIsReadingByCamera(true);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.check),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  child: const Icon(Icons.find_replace_sharp),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
