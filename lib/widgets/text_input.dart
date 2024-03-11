import 'package:flutter/cupertino.dart';

class FragmentTextInput extends StatelessWidget {
  final String placeholder;
  final bool obscureText;
  final IconData? icon;
  final VoidCallback? onEditingComplete;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? autocorrect;
  final int? minLines;
  final int? maxLines;

  const FragmentTextInput(
      {super.key,
      required this.placeholder,
      this.obscureText = false,
      this.autocorrect = false,
      this.icon,
      this.minLines = 1,
      this.maxLines = 1,
      this.onEditingComplete,
      this.controller,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: keyboardType,
      onEditingComplete: () {
        onEditingComplete?.call();
        FocusScope.of(context).unfocus();
      },
      placeholder: placeholder,
      placeholderStyle: const TextStyle(
        color: Color.fromARGB(255, 62, 62, 62),
      ),
      textAlignVertical: TextAlignVertical.top,
      padding: const EdgeInsets.all(10.0),
      minLines: minLines,
      maxLines: maxLines,
      autocorrect: autocorrect!,
      obscureText: obscureText,
      prefix: icon != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Icon(
                icon,
                color: const Color.fromARGB(255, 30, 30, 30),
              ),
            )
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(255, 30, 30, 30),
          width: 1.0,
        ),
      ),
    );
  }
}
