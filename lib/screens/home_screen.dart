import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/api/models/widget.dart';
import 'package:gradebook/api/services/widget.dart';
import 'package:gradebook/common/fragments_icons.dart';
import 'package:gradebook/screens/clubs_screen.dart';
import 'package:gradebook/screens/service_screen.dart';
import 'package:gradebook/widgets/fragment.dart';
import 'package:gradebook/widgets/fragments/clubs.dart';
import 'package:gradebook/widgets/fragments/service.dart';
import 'package:gradebook/widgets/fragments/sports.dart';
import 'package:gradebook/widgets/icon_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<QuerySnapshot<IWidget>> widgetsStreamController = StreamController();
  final WidgetsService _widgetsService = WidgetsService();

  bool isEditing = false;
  bool _isLoadingWidgets = true;

  @override
  void initState() {
    super.initState();
    widgetsStreamController.addStream(_widgetsService.getWidgets().asStream()).then((value) => setState(() {
          _isLoadingWidgets = false;
        }));
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  void refreshWidgets() async {
    setState(() {
      _isLoadingWidgets = true;
    });
    debugPrint("Reloading Records");
    await Future.delayed(const Duration(milliseconds: 500));
    await _widgetsService.getWidgets().then((value) {
      debugPrint("Successfully Reloaded Records");
      widgetsStreamController.add(value);
    }).whenComplete(() => setState(() {
          _isLoadingWidgets = false;
        }));
  }

  Widget _buildWidgetsListView(BuildContext context, List<QueryDocumentSnapshot<IWidget>> snapshot) {
    return 
    
      ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
      children: [
        ...snapshot.map((data) {
          final widget = data.data();

          if (widget.name == "service") {
            return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Center(
                  child: Fragment(
                    name: "Service",
                    editing: isEditing,
                    actionLabel: "Record Your Service Hours",
                    onDelete: () {
                      debugPrint("Deleting Service Fragment");

                      _widgetsService.deleteWidget(data.id).then((value) {
                        refreshWidgets();
                      });
                    },
                    onTap: () async {
                      final update = await Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const ServiceScreen(),
                        ),
                      );

                      debugPrint("Update: $update");
                    },
                    child: const ServiceFragment(),
                  ),
                ));
          } else if (widget.name == "sports") {
            return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(
                  child: Fragment(
                    name: "Sports",
                    editing: isEditing,
                    actionLabel: "Document Personal Records",
                    onTap: () {
                      debugPrint("Sports Fragment Pressed");
                    },
                    child: const SportsFragment(),
                  ),
                ));
          } else if (widget.name == "clubs") {
            return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(
                  child: Fragment(
                    name: "Clubs",
                    editing: isEditing,
                    actionLabel: "Record Your Clubs",
                    onDelete: () {
                      debugPrint("Deleting Service Fragment");

                      _widgetsService.deleteWidget(data.id).then((value) {
                        refreshWidgets();
                      });
                    },
                    onTap: () async {
                      final update = await Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const ClubsScreen(),
                        ),
                      );

                      debugPrint("Update: $update");
                    },
                    child: const ClubsFragment(),
                  ),
                ));
          } else {
            return const SizedBox.shrink();
          }
        }),
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
              style: TextStyle(color: Color.fromARGB(255, 52, 52, 52), fontSize: 15),
              children: [
                WidgetSpan(
                  child: Icon(FragmentsIcons.pencil, size: 20, color: Color.fromARGB(255, 52, 52, 52)),
                ),
                TextSpan(
                  text: " to add Fragments",
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildWidgets() {
    return StreamBuilder<QuerySnapshot<IWidget>>(
      stream: widgetsStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return _buildWidgetsListView(context, snapshot.data!.docs);
      },
    );
  }

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
                    "Hello, Student",
                    style: TextStyle(color: Color.fromARGB(255, 177, 177, 177), fontSize: 22),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    getGreeting(),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: _isLoadingWidgets ? const CupertinoActivityIndicator() : FragmentsIconButton(
                          icon: const Icon(
                            CupertinoIcons.arrow_clockwise,
                            size: 25,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            refreshWidgets();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 10, 10, 10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FragmentsIconButton(
                        onTap: () {
                          HapticFeedback.selectionClick();

                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        icon: Icon(
                          isEditing ? CupertinoIcons.checkmark_alt : FragmentsIcons.pencil,
                          size: 25,
                          color: isEditing
                              ? const Color.fromARGB(255, 68, 155, 71)
                              : const Color.fromARGB(255, 52, 52, 52),
                        ),
                      ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedOpacity(
                        opacity: isEditing ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 10, 10, 10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:FragmentsIconButton(
                        onTap: () {
                          debugPrint("Add button pressed");

                          showCupertinoModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            topRadius: const Radius.circular(35),
                            backgroundColor: const Color.fromARGB(255, 10, 10, 10),
                            builder: (context) => Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                //   color: const Color.fromARGB(255, 10, 10, 10),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 10, 10, 10),
                                    border: Border(
                                      bottom: BorderSide(
                                        //                   <--- right side
                                        color: Color.fromARGB(255, 32, 32, 32),
                                        width: 1.0,
                                      ),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Widgets Gallery",
                                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Pick & Choose Widgets to Add to Your Home Screen.",
                                        style: TextStyle(color: Color.fromARGB(255, 52, 52, 52), fontSize: 16),
                                      ),
                                      const SizedBox(height: 25),
                                      Expanded(
                                          child: ListView(
                                        children: [
                                          Fragment(
                                            name: "Service",
                                            actionLabel: "Add Service Fragment",
                                            preview: true,
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              refreshWidgets();
                                            },
                                            child: const ServiceFragment(),
                                          ),
                                          const SizedBox(height: 15),
                                          Fragment(
                                            name: "Clubs",
                                            actionLabel: "Add Clubs Fragment",
                                            preview: true,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              refreshWidgets();
                                            },
                                            child: const ClubsFragment(),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                )),
                          );
                        },
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 25,
                          color: Color.fromARGB(255, 52, 52, 52),
                        ),
                      ),
                      )
                      )
                    ],
                  ),
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
        const SizedBox(height: 10),
        Expanded(child: _buildWidgets())
      ],
    )));
  }
}
