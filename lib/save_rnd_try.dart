/*
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/camera_provider.dart';
import 'package:ict_acc_mathematics/widgets/text_recognizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imagePck;

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
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    //_recognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
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
              Center(
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                ),
              )
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

            var a = await image.readAsBytes();

            var imgTemp = imagePck.Image.fromBytes(width: 200, height: 300, bytes: a.buffer);

            developer.log('${imgTemp.height}');
            var jpg = imagePck.encodeJpg(imgTemp);
            var c = imagePck.copyCrop(imgTemp, x: 0, y: 0, width: 100, height: 100);

            Uint8List encodedPng = Uint8List.fromList(imagePck.encodePng(imgTemp));

            var rng = Random();
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;

            String filePath = '$tempPath${rng.nextInt(100) + 1}.png';
            File file = File(filePath);

            await file.writeAsBytes(encodedPng);

            /*
            Image imageImage = Image(
              image: ResizeImage(FileImage(File(image.name)), width: 100, height: 300),
            );

         
            Uint8List? bytes = await imageToBytes(imageImage);
            // generate random number.
            var rng = new Random();
// get temporary directory of device.
            Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
            String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
            File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.

// write bodyBytes received in response to file.
            await file.writeAsBytes(imageImage);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
*/
            String recognizedText = await _recognizer.processImageBytes(encodedPng);
            developer.log(recognizedText);

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: jpg,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            // ignore: avoid_print
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
/*
  //final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  final ImagePicker _picker = ImagePicker();
  final ImageTextRecognizer _recognizer = ImageTextRecognizer();

  String? imgPath;
  String? recognizedText;

  Future<String?> obtainImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.path;
  }

  @override
  Widget build(BuildContext context) {
    //String text = "";
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          imgPath = await obtainImage(ImageSource.camera);
          if (imgPath != null) {
            recognizedText = await _recognizer.processImage(imgPath!);
            debugPrint(recognizedText);
          } else {
            debugPrint('Image not obrained!!!');
          }
        },
        child: const Text('Take photo'),
      ),
    );
  }
  */
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.memory(imagePath),
    );
  }
}
*/