import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/common/fragments_icons.dart';
import 'package:gradebook/screens/login_screen.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello, Mahit",
                        style: TextStyle(
                          color: Color.fromARGB(255, 177, 177, 177),
                          fontSize: 22
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Good Evening",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 30
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 10, 10, 10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(7.5, 5, 7.5, 5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  // CupertinoScaffold.showCupertinoModalBottomSheet(
                                  //   expand: true,
                                  //   context: context,
                                  //   backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                  //   builder: (context) => Stack(
                                  //     children: <Widget>[
                                  //       const CupertinoPageScaffold(
                                  //         child: Center(),
                                  //       ),
                                  //       Positioned(
                                  //         height: 40,
                                  //         left: 40,
                                  //         right: 40,
                                  //         bottom: 20,
                                  //         child: CupertinoButton(
                                  //           onPressed: () => {},
                                  //           child: const Text('Pop back home'),
                                  //         ),
                                  //       )
                                  //     ],
                                  // )
                                  // );
                                },
                                child: const Icon(
                                  FragmentsIcons.pencil,
                                  size: 25,
                                  color: Color.fromARGB(255, 52, 52, 52),
                                ),
                              ),
                              const SizedBox(width: 7.5),
                              Container(
                                width: 1,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 52, 52, 52),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                              ),
                              const SizedBox(width: 7.5),
                              GestureDetector(
                                onTap: () {
                                  debugPrint("Settings button pressed");
                                  HapticFeedback.selectionClick();
                                  // TODO: Make Settings Page
                                  FirebaseAuth.instance.signOut();
                                
                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                    CupertinoPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child:  const Icon(
                                  FragmentsIcons.cog,
                                  size: 25,
                                  color:Color.fromARGB(255, 52, 52, 52),
                                ),
                              ),
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/svg/logo.svg",
                    semanticsLabel: 'Logo',
                    height: 75,
                    width: 75,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: SvgPicture.asset( 
                "assets/svg/add_fragments.svg", 
                semanticsLabel: 'Add Fragments', 
                height: 250, 
                width: MediaQuery.of(context).size.width, 
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            const Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: "Click ",
                style: TextStyle(
                  color: Color.fromARGB(255, 52, 52, 52),
                  fontSize: 15
                ),
                children: [
                  WidgetSpan(
                    child: Icon(
                      FragmentsIcons.pencil,
                      size: 20,
                      color: Color.fromARGB(255, 52, 52, 52)
                    ),
                  ),
                  TextSpan(
                    text: " to add Fragments",
                  ),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}
