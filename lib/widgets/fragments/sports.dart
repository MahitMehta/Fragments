import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class SportsFragment extends StatefulWidget {
  const SportsFragment({super.key});

  @override
  State<SportsFragment> createState() => _SportsFragmentState();
}

class _SportsFragmentState extends State<SportsFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/svg/sports_one_v2.svg",
            height: 150,
            width: 300,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
