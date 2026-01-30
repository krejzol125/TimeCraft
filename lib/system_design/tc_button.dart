import 'package:flutter/material.dart';

class TcButton extends StatelessWidget {
  const TcButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.primary = true,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primary
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: primary
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
