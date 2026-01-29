import 'package:flutter/material.dart';

class TcStepper extends StatelessWidget {
  const TcStepper({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(min, max);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            onPressed: v > min ? () => onChanged(v - 1) : null,
            icon: const Icon(Icons.remove_rounded),
            color: Colors.grey.withValues(alpha: 0.45),
          ),
          Text(
            '$v',
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.45),
              fontWeight: FontWeight.w900,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            onPressed: v < max ? () => onChanged(v + 1) : null,
            icon: const Icon(Icons.add_rounded),
            color: Colors.grey.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
