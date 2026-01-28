import 'package:flutter/material.dart';

class TcInputDecorator extends StatelessWidget {
  const TcInputDecorator({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    required this.child,
  });

  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      child: child,
    );
  }
}
