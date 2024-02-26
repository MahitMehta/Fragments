import 'package:flutter/cupertino.dart';

class FragmentTextInput extends StatelessWidget {
    final String placeholder; 
    final bool obscureText; 
    final IconData? icon; 
    final VoidCallback? onEditingComplete;
    final TextEditingController? controller;

    const FragmentTextInput({
      super.key,
      required this.placeholder,  
      this.obscureText = false, 
      this.icon,
      this.onEditingComplete,
      this.controller
    });

    @override
    Widget build(BuildContext context) {
      return CupertinoTextField(
        controller: controller,
        onEditingComplete: () {
          onEditingComplete?.call();
          FocusScope.of(context).unfocus();
        },
        placeholder: placeholder,
        placeholderStyle: const TextStyle(
          color: Color.fromARGB(255, 62, 62, 62),
        ),
        padding: const EdgeInsets.all(10.0),
        autocorrect: false,
        obscureText: obscureText,
        prefix: icon != null ? Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 30, 30, 30),
          ),
        ) : null,
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