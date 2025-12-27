import 'package:flutter/material.dart';

class TcRadioButton extends StatelessWidget {
  const TcRadioButton({
    super.key,
    required this.onTap,
    required this.selected,
    required this.child,
    this.color,
  });

  final void Function() onTap;
  final bool selected;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? (color ?? Theme.of(context).colorScheme.primary).withValues(
                  alpha: 0.10,
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? (color ?? Theme.of(context).colorScheme.primary)
                : Colors.grey,
            width: selected ? 1.4 : 1.1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
