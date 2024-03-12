import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class EmptyRecord extends StatefulWidget {
  const EmptyRecord({Key? key}) : super(key: key);

  @override
  State<EmptyRecord> createState() => _EmptyRecordState();
}

class _EmptyRecordState extends State<EmptyRecord> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(milliseconds: 250), vsync: this)..forward();

  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _opacityAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: <Widget>[
              const SizedBox(height: 20), // Add some space (optional
              SvgPicture.asset(
                'assets/svg/empty.svg',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(height: 20),
              const Text(
                'No records found.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 52, 52, 52)),
              ),
            ])
          ],
        ));
  }
}
