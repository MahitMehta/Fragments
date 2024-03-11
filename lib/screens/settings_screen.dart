import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/screens/login_screen.dart';
import 'package:gradebook/widgets/button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(
                "assets/svg/settings.svg",
            
                width: MediaQuery.of(context).size.width - 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              FragmentsButton(
                label: "Update Profile",
                type: FragmentsButtonType.dark,
                icon: CupertinoIcons.person,
                onTap: () {

                },
              ),
              const SizedBox(height: 10),
              FragmentsButton(
                label: "Terms & Conditions",
                type: FragmentsButtonType.dark,
                icon: CupertinoIcons.doc,
                onTap: () {

                },
              ),
              const SizedBox(height: 10),
              FragmentsButton(
                label: "Privacy Policy",
                type: FragmentsButtonType.dark,
                icon: CupertinoIcons.lock,
                onTap: () {

                },
              ),
            ],
          ),
          FragmentsButton(
            type: FragmentsButtonType.gradient,
            icon: CupertinoIcons.arrow_left_square,
            onTap: logOut,
            label: "Log Out",
          ),
        ],
      ),
    )));
  }
}
