import 'package:flutter/material.dart';
import 'package:timecraft/system_design/tc_radio_button.dart';

class PriorityField extends StatelessWidget {
  PriorityField({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;
  final colors = [Colors.green, Colors.grey, Colors.orange, Colors.red];

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Priority',
        prefixIcon: const Icon(Icons.flag_outlined),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        contentPadding: const EdgeInsets.all(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (i) {
          final p = i + 1;
          final selected = p == value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TcRadioButton(
                selected: selected,
                color: colors[i],
                onTap: () => onChanged(p),
                child: Text(
                  '$p',
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
