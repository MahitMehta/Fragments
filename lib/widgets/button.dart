import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum FragmentsButtonType {
  gradient,
  matte
}

class FragmentsButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final AssetImage? image;  
  final FragmentsButtonType type;
  final bool disabled;

  const FragmentsButton({
    Key? key, 
    required this.onTap, 
    this.label = "", 
    this.disabled = false,
    this.image,
    this.type = FragmentsButtonType.matte
  }) : super(key: key);

  @override
  State<FragmentsButton> createState() => _FragmentsButtonState();
}

class _FragmentsButtonState extends State<FragmentsButton> {
  bool _isPressed = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.selectionClick();
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: AnimatedOpacity(
        opacity: _isPressed || widget.disabled ? 0.65 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: FragmentsButtonType.matte == widget.type ? const Color.fromARGB(255, 30, 30, 30) : null,
            borderRadius: BorderRadius.circular(5),
            gradient: widget.type == FragmentsButtonType.gradient ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.mirror,
              colors: [
                Color.fromARGB(255, 154, 106, 255),
                Color.fromARGB(255, 239, 192, 23),
              ],
            ) : null,
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.image != null) Image(image: widget.image!, width: 20, height: 20),
                if (widget.image != null && widget.label != "") const SizedBox(width: 5),
                Text(widget.label)
              ],
            )
          ),
        )
      )
    );
  }
}