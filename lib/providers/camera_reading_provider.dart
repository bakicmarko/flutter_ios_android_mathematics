import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraReadingProvider extends StateNotifier<bool> {
  CameraReadingProvider() : super(false);

  void setIsReadingByCamera(bool isFromCamera) {
    state = isFromCamera;
  }
}

final cameraReadingProvider = StateNotifierProvider<CameraReadingProvider, bool>(
  (ref) => CameraReadingProvider(),
);
