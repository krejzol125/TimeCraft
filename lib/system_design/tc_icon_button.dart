import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TcIconCheckButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool selected;
  TcIconCheckButton({required this.icon, this.onTap, this.selected = false});

  Widget build(BuildContext context) => switch (selected) {
    true => IconButton(
      onPressed: onTap,
      icon: icon,
      //color: Theme.of(context).colorScheme.primary,
      isSelected: true,
    ),
    false => IconButton(onPressed: onTap, icon: icon, isSelected: false),
  };
}
