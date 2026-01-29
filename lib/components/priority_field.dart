import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/system_design/tc_input_decorator.dart';
import 'package:timecraft/system_design/tc_radio_picker.dart';

class PriorityField extends StatelessWidget {
  const PriorityField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (1, l10n.priorityLow),
      (2, l10n.priorityMedium),
      (3, l10n.priorityHigh),
      (4, l10n.priorityUrgent),
    ];
    return TcInputDecorator(
      labelText: l10n.priority,
      prefixIcon: const Icon(Icons.flag_outlined),
      child: TcRadioPicker<int>(
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
