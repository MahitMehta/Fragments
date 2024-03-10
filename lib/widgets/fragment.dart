import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Fragment extends StatefulWidget {
  final String name; 
  final String actionLabel; 
  final VoidCallback onTap;
  final Widget child; 

  const Fragment({
    super.key, 
    required this.name, 
    required this.actionLabel,
    required this.onTap,
    required this.child
  });

  @override
  State<Fragment> createState() => _FragmentState();
}

class _FragmentState extends State<Fragment> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "${widget.name} Fragment",
            style: const TextStyle(
              color: Color.fromARGB(255, 52, 52, 52),
              fontSize: 15
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 235,
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 15, 15, 15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color.fromARGB(255, 32, 32, 32),
              width: 1
            )
          ),
          child: Column(
            children: [
              Expanded(
                child: widget.child
              ),
              GestureDetector(
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
                    widget.onTap();
                  },
                  child:
                   Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 10, 10, 10),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      )
                    ),
                    child:
                    AnimatedOpacity( 
                    opacity: _isPressed ? 0.65 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.actionLabel,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 177, 177, 177),
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        CupertinoIcons.chevron_right_circle,
                        color: Color.fromARGB(255, 177, 177, 177),
                      )
                    ],
                  ),
                  )
                )
              )
            ],
          ),
        )
      ],
    );
  }
}