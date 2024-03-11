import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/common/fragments_icons.dart';
import 'package:gradebook/screens/settings_screen.dart';
import 'package:gradebook/screens/home_screen.dart';

class MainTabNavigator extends StatelessWidget {
  const MainTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        inactiveColor: const Color.fromARGB(255, 255, 255, 255),
        activeColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: (value) => {HapticFeedback.selectionClick()},
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FragmentsIcons.home,
              // shadows: [Shadow(blurRadius: 3, color: Color.fromARGB(255, 255, 255, 255), offset: Offset(0, 0))],
            ),
            // label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FragmentsIcons.cog,
              // shadows: [Shadow(blurRadius: 3, color: Color.fromARGB(255, 255, 255, 255), offset: Offset(0, 0))],
            ),
            // label: "Bulletin"
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(builder: (BuildContext context) {
          return Stack(
            children: [
              index == 0 ? const HomeScreen() : const SettingsScreen(),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 10, 10, 10),
                        border: Border(top: BorderSide(color: Color.fromARGB(255, 32, 32, 32), width: 1))),
                  )),
              Positioned(
                left: index == 0
                    ? MediaQuery.of(context).size.width / 4 - 35
                    : MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 4 - 35,
                bottom: 0,
                child: Container(
                    height: 5,
                    width: 75,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          Color.fromARGB(255, 154, 106, 255),
                          Color.fromARGB(255, 239, 192, 23),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(color: Color.fromARGB(255, 172, 125, 206), blurRadius: 10, offset: Offset(0, 1)),
                      ],
                    )),
              )
            ],
          );
        });
      },
    );
  }
}
