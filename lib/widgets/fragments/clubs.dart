import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ClubsFragment extends StatefulWidget {
  const ClubsFragment({super.key});

  @override
  State<ClubsFragment> createState() => _ClubsFragmentState();
}

class _ClubsFragmentState extends State<ClubsFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/svg/club.svg",
            height: 150,
            width: 300,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
