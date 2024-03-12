import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ScoresFragment extends StatefulWidget {
  const ScoresFragment({super.key});

  @override
  State<ScoresFragment> createState() => _ScoresFragmentState();
}

class _ScoresFragmentState extends State<ScoresFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/svg/exams.svg",
            height: 150,
            width: 300,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
