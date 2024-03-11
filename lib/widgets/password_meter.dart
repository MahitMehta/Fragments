import 'package:flutter/cupertino.dart';

class PasswordMeter extends StatelessWidget {
  final String password;

  const PasswordMeter({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 5.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: [
                        Color.fromARGB(255, 154, 106, 255),
                        Color.fromARGB(255, 239, 192, 23),
                      ],
                    )),
              ),
            ),
            Expanded(
              child: Container(
                height: 5.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: [
                        Color.fromARGB(255, 154, 106, 255),
                        Color.fromARGB(255, 239, 192, 23),
                      ],
                    )),
              ),
            ),
            Expanded(
              child: Container(
                height: 5.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: [
                        Color.fromARGB(255, 154, 106, 255),
                        Color.fromARGB(255, 239, 192, 23),
                      ],
                    )),
              ),
            )
          ],
        )
      ],
    );
  }
}
