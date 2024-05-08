import 'package:flutter_riverpod/flutter_riverpod.dart';

// is light theme active
class ResetProvider extends StateNotifier<bool> {
  ResetProvider() : super(false);

  void switchState() {
    state = !state;
  }
}

final resetProvider = StateNotifierProvider<ResetProvider, bool>(
  (ref) => ResetProvider(),
);
