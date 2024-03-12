import 'package:flutter/cupertino.dart';
import 'package:gradebook/widgets/button.dart';

class ShareMenu extends StatelessWidget {
  final VoidCallback? onShareIG;
  final VoidCallback? onShareFB;
  final VoidCallback? onShareFBDirectly;

  const ShareMenu({super.key, this.onShareFB, this.onShareIG, this.onShareFBDirectly});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 10, 10, 10),
        ),
        width: MediaQuery.of(context).size.width,
        height: 275,
        child: Column(children: [
          const Text(
            "Share Record",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 15),
          FragmentsButton(
              image: const AssetImage("assets/icons/instagram.png"),
              type: FragmentsButtonType.matte,
              label: " Share to your Instagram Story",
              onTap: () {
                if (onShareIG != null) {
                  onShareIG!();
                }
              }),
          const SizedBox(height: 10),
          FragmentsButton(
              image: const AssetImage("assets/icons/facebook.png"),
              type: FragmentsButtonType.matte,
              label: " Share to your Facebook Story",
              onTap: () {
                if (onShareFB != null) {
                  onShareFB!();
                }
              }),
          const SizedBox(height: 10),
          FragmentsButton(
              image: const AssetImage("assets/icons/facebook.png"),
              type: FragmentsButtonType.matte,
              label: " Create Facebook Post Directly",
              onTap: () {
                if (onShareFB != null) {
                  onShareFBDirectly!();
                }
              }),
        ]));
  }
}
