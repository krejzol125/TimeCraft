import 'package:flutter/material.dart';
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

  final items = const [(1, 'low'), (2, 'medium'), (3, 'high'), (4, 'urgent')];

  @override
  Widget build(BuildContext context) {
    return TcInputDecorator(
      labelText: 'Priority',
      prefixIcon: const Icon(Icons.flag_outlined),
      child: TcRadioPicker<int>(
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
