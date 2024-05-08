// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/numbers_provider.dart';
import 'package:ict_acc_mathematics/providers/operation_type_provider.dart';
import 'package:ict_acc_mathematics/providers/settings_provider.dart';
import 'package:ict_acc_mathematics/screens/operation_screens/addition_screen.dart';
import 'package:ict_acc_mathematics/screens/camera_screen.dart';
import 'package:ict_acc_mathematics/screens/operation_screens/division_screen.dart';
import 'package:ict_acc_mathematics/screens/operation_screens/multiplication_screen.dart';
import 'package:ict_acc_mathematics/screens/settings_screen.dart';
import 'package:ict_acc_mathematics/screens/operation_screens/substraction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    //required this.camera,
  });

  //final CameraDescription camera;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool resetScreen = false;

  /*
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(cameraProvider.notifier).setCamera(widget.camera));
  }
  */

  void _selectScreen(int ind) {
    if (ind == 1) {
      final nums = ref.read(numbersProvider);
      if (nums[0] < nums[1]) {
        log('Swapping numbers...', name: 'build');
        ref.read(numbersProvider.notifier).setNumbers([nums[1], nums[0]]);
      }
    }
    ref.read(operationTypeProvider.notifier).setOperation(OperationType.getEnum(ind));
  }

  @override
  Widget build(BuildContext context) {
    final operatonType = ref.watch(operationTypeProvider);
    final settings = ref.watch(settingsProvider);
    String operationName = AppLocalizations.of(context)!.addition;
    Widget activeScreen = AdditionScreen(reset: resetScreen);
    if (operatonType == OperationType.substraction) {
      activeScreen = const SubstractionScreen();
      operationName = AppLocalizations.of(context)!.substraction;
    }
    if (operatonType == OperationType.multiplication) {
      activeScreen = const MultiplicationScreen();
      operationName = AppLocalizations.of(context)!.multiplication;
    }
    if (operatonType == OperationType.division) {
      activeScreen = const DivisionScreen();
      operationName = AppLocalizations.of(context)!.division;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text(operationName),
        actions: [
          IconButton(
            onPressed: () {
              //ref.read(resetProvider.notifier).switchState(),
              setState(
                () {
                  resetScreen = !resetScreen;
                  ref.read(numbersProvider.notifier).generateNewNumbers(settings[0], settings[1],
                      isSubstraction: operatonType == OperationType.substraction);
                },
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  resetScreen = !resetScreen;
                });
              });
            },
            icon: const Icon(Icons.autorenew),
          ),
          IconButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CameraScreen())),
            },
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
        selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.add), label: AppLocalizations.of(context)!.add),
          BottomNavigationBarItem(icon: const Icon(Icons.remove), label: AppLocalizations.of(context)!.sub),
          BottomNavigationBarItem(icon: const Icon(Icons.close), label: AppLocalizations.of(context)!.multi),
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.divide), label: AppLocalizations.of(context)!.div),
        ],
        currentIndex: operatonType.ind,
        onTap: _selectScreen,
      ),
      body: activeScreen,
    );
  }
}
