import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/api/services/widget.dart';
import 'package:gradebook/widgets/icon_button.dart';

class Fragment extends StatefulWidget {
  final String name;
  final String actionLabel;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final Widget child;
  final bool? preview;
  final bool? editing;

  const Fragment(
      {super.key,
      this.preview = false,
      this.editing = false,
      this.onDelete,
      required this.name,
      required this.actionLabel,
      required this.onTap,
      required this.child});

  @override
  State<Fragment> createState() => _FragmentState();
}

class _FragmentState extends State<Fragment> {
  final WidgetsService _widgetsService = WidgetsService();
  bool _isPressed = false;
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "${widget.name} Fragment",
                style: const TextStyle(color: Color.fromARGB(255, 52, 52, 52), fontSize: 15),
              ),
            ),
            widget.editing!
                ? Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: FragmentsIconButton(
                      icon: const Icon(
                        CupertinoIcons.trash,
                        color: Color.fromARGB(255, 200, 55, 44),
                        size: 18,
                      ),
                      onTap: () {
                        widget.onDelete!();
                      },
                    ))
                : const SizedBox.shrink()
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 235,
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 15, 15, 15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color.fromARGB(255, 32, 32, 32), width: 1)),
          child: Column(
            children: [
              Expanded(child: widget.child),
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
                  onTap: () async {
                    if (widget.preview!) {
                      setState(() {
                        _isAdding = true;
                      });

                      await Future.delayed(const Duration(milliseconds: 250));
                      await _widgetsService.addWidget(widget.name).then((value) {
                        setState(() {
                          _isAdding = false;
                        });
                      });
                    }

                    widget.onTap();
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: 42,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 10, 10, 10),
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                      child: AnimatedOpacity(
                        opacity: _isPressed ? 0.65 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.actionLabel,
                              style: const TextStyle(color: Color.fromARGB(255, 177, 177, 177), fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            _isAdding
                                ? const CupertinoActivityIndicator()
                                : Icon(
                                    widget.preview! ? CupertinoIcons.add_circled : CupertinoIcons.chevron_right_circle,
                                    color: widget.preview!
                                        ? const Color.fromARGB(255, 68, 155, 71)
                                        : const Color.fromARGB(255, 177, 177, 177),
                                  )
                          ],
                        ),
                      )))
            ],
          ),
        )
      ],
    );
  }
}
