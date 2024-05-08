import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProvider extends StateNotifier<List<int>> {
  SettingsProvider()
      : super(
          [
            3,
            3,
          ],
        );

  void setFirstNumberDigitCount(int firstNumberDigitCount) {
    state[0] = firstNumberDigitCount;
  }

  void setSecondNumberDigitCount(int secondNumberDigitCount) {
    state[1] = secondNumberDigitCount;
  }
}

final settingsProvider = StateNotifierProvider<SettingsProvider, List<int>>((ref) {
  return SettingsProvider();
});
