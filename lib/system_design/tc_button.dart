import 'package:flutter/material.dart';

class TcButton extends StatelessWidget {
  const TcButton({
    super.key,
    required this.onTap,
    required this.child,
    this.outlined = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: outlined
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.4,
                )
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
