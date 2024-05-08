import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Language {
  english(name: 'English', code: 'en'),
  hrvatski(name: 'Hrvatski', code: 'hr'),
  french(name: 'Français', code: 'fr'),
  spanish(name: 'Español', code: 'es'),
  portuguese(name: 'Português', code: 'pt'),
  hungarian(name: 'Magyar', code: 'hu');

  const Language({required this.name, required this.code});
  final String name;
  final String code;
}

class LanguageProvider extends StateNotifier<Language> {
  LanguageProvider() : super(Language.english);

  void updateLanguage(Language newLanguage) {
    state = newLanguage;
  }
}

final languageProvider = StateNotifierProvider<LanguageProvider, Language>((ref) => LanguageProvider());
