import 'package:flutter/cupertino.dart';

class FragmentsIconButton extends StatefulWidget {
  const FragmentsIconButton({super.key, this.onTap, this.icon});

  final VoidCallback? onTap;
  final Widget? icon;

  @override
  State<FragmentsIconButton> createState() => _FragmentsIconButtonState();
}

class _FragmentsIconButtonState extends State<FragmentsIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isPressed = false;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: widget.onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isPressed ? 0.5 : 1,
        child: widget.icon,
      ),
    );
  }
}
