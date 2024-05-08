import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraProvider extends StateNotifier<CameraDescription?> {
  CameraProvider() : super(null);

  void setCamera(CameraDescription camera) {
    state = camera;
  }
}

final cameraProvider = StateNotifierProvider<CameraProvider, CameraDescription?>(
  (ref) => CameraProvider(),
);
