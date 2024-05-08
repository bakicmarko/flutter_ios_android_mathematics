import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict_acc_mathematics/providers/camera_provider.dart';
import 'package:ict_acc_mathematics/providers/language_provider.dart';
import 'package:ict_acc_mathematics/providers/theme_provider.dart';
import 'package:ict_acc_mathematics/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.lato().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 197, 76, 181),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.lato().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 197, 76, 181),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    ProviderScope(child: App(camera: firstCamera)),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key, required this.camera});

  final CameraDescription camera;

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(cameraProvider.notifier).setCamera(widget.camera));
  }

  @override
  Widget build(BuildContext context) {
    final isLightThemeActive = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp(
      //theme: isLightThemeActive ? lightTheme : darkTheme,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isLightThemeActive ? ThemeMode.light : ThemeMode.dark,

      // internationalizing
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /*
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hr'),
        Locale('fr'),
        Locale('es'),
        Locale('pt'),
        Locale('hu'),
      ],
      */
      locale: Locale(language.code),

      home: const HomeScreen(),
    );
  }
}
