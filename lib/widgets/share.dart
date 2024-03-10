import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Share extends StatelessWidget {
  final VoidCallback onTap; 

  const Share({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child:  const Icon(
        CupertinoIcons.share,
        size: 25,
        color: Color.fromARGB(255, 52, 52, 52),
      ),
    );
  }
}
