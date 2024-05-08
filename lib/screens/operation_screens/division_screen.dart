import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ict_acc_mathematics/providers/numbers_provider.dart';
import 'package:ict_acc_mathematics/providers/operation_type_provider.dart';

class DivisionScreen extends ConsumerWidget {
  const DivisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(numbersProvider);
    final operation = ref.watch(operationTypeProvider).toString();
    return Center(child: Text('${numbers[0]} $operation ${numbers[1]} = ...'));
  }
}
