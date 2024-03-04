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
  final bool loading;

  const FragmentsButton({
    super.key, 
    this.label = "", 
    this.image,
    this.disabled = false,
    this.loading = false,
    this.type = FragmentsButtonType.matte,
    required this.onTap, 
  });

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
      onPanEnd: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: () {
        if (widget.disabled || widget.loading) return; 
        widget.onTap();
      },
      child: AnimatedOpacity(
        opacity: _isPressed || widget.disabled || widget.loading ? 0.65 : 1.0,
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
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.image != null) Image(image: widget.image!, width: 20, height: 20),
                    if (widget.image != null && widget.label != "") const SizedBox(width: 5),
                    Text(widget.label)
                  ],
                ),
                if (widget.loading) Positioned(
                  left: 5,
                  child: CupertinoActivityIndicator(
                    animating: widget.loading,
                    radius: 10,
                  ),
                )
              ],
            )
          ),
        )
      )
    );
  }
}