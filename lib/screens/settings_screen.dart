import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/language_provider.dart';
import 'package:ict_acc_mathematics/providers/settings_provider.dart';
import 'package:ict_acc_mathematics/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// -	Intervali brojeva -
/// -	Odabir jezika, HRV ENG, LIBRARY ZA X JEZIKA ZA KOJI POSTOJE TRENUTNO
///

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightThemeAactive = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.general, style: Theme.of(context).textTheme.headlineSmall),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).colorScheme.onBackground,
              height: 1.5,
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${AppLocalizations.of(context)!.settingsFirstNumberDigits}:'),
                    DropdownMenu<int>(
                      initialSelection: settings[0],
                      enableSearch: false,
                      width: 100,
                      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: true,
                          ),
                      dropdownMenuEntries: [1, 2, 3, 4, 5, 6]
                          .map((entry) => DropdownMenuEntry(value: entry, label: entry.toString()))
                          .toList(),
                      onSelected: (value) {
                        ref.read(settingsProvider.notifier).setFirstNumberDigitCount(value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${AppLocalizations.of(context)!.settingsSecondNumberDigits}:'),
                    DropdownMenu<int>(
                      initialSelection: settings[1],
                      enableSearch: false,
                      width: 100,
                      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: true,
                          ),
                      dropdownMenuEntries: [1, 2, 3, 4, 5, 6]
                          .map((entry) => DropdownMenuEntry(value: entry, label: entry.toString()))
                          .toList(),
                      onSelected: (value) {
                        ref.read(settingsProvider.notifier).setSecondNumberDigitCount(value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${AppLocalizations.of(context)!.language}:'),
                    DropdownMenu<Language>(
                      initialSelection: language,
                      enableSearch: false,
                      width: 150,
                      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: true,
                          ),
                      dropdownMenuEntries:
                          Language.values.map((entry) => DropdownMenuEntry(value: entry, label: entry.name)).toList(),
                      onSelected: (value) {
                        ref.read(languageProvider.notifier).updateLanguage(value!);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 100),
            Text(AppLocalizations.of(context)!.theme, style: Theme.of(context).textTheme.headlineSmall),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).colorScheme.onBackground,
              height: 1.5,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context)!.lightTheme}:'),
                Row(
                  children: [
                    const Text('Off'),
                    Switch(
                      value: isLightThemeAactive,
                      onChanged: (newVall) => ref.read(themeProvider.notifier).switchTheme(),
                    ),
                    const Text('On'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
