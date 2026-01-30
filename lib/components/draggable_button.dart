import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class DraggableButton extends StatefulWidget {
  const DraggableButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<DraggableButton> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _yToxRatio = 0;
  late AnimationController _springController;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController.unbounded(vsync: this)
      ..animateWith(SpringSimulation(_defaultSpring, 0, 0, 0));
    _springController.addListener(() {
      setState(() {
        _dragOffset = Offset(
          _springController.value,
          _springController.value * _yToxRatio,
        );
      });
    });
  }

  double _mass = 1;
  double _stiffness = 200;
  double _damping = 15;
  SpringDescription get _defaultSpring =>
      SpringDescription(mass: _mass, stiffness: _stiffness, damping: _damping);

  void _onPanStart(DragStartDetails details) {
    _springController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _yToxRatio = _dragOffset.dy / _dragOffset.dx;
    _springController.animateWith(
      SpringSimulation(_defaultSpring, _dragOffset.dx, 0, 0),
    );
  }

  // void _resetCard() {
  //   setState(() {
  //     _springController.stop();
  //     _dragOffset = Offset.zero;
  //   });
  // }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _dragOffset,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
