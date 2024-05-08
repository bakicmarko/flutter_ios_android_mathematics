import 'package:flutter_riverpod/flutter_riverpod.dart';

// is light theme active
class ThemeProvider extends StateNotifier<bool> {
  ThemeProvider() : super(true);

  void switchTheme() {
    state = !state;
  }
}

final themeProvider = StateNotifierProvider<ThemeProvider, bool>(
  (ref) => ThemeProvider(),
);
