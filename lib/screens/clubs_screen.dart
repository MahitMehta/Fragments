import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/api/models/club.dart';
import 'package:gradebook/api/services/club.dart';
import 'package:gradebook/screens/create_club_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/club_record.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  static const igShareChannel = MethodChannel('com.mahitm.fragments/igShare');
  final ClubService _clubsService = ClubService();

  StreamController<QuerySnapshot<IClubRecord>> recordStreamController = StreamController();
  bool _isLoadingRecords = true;
  bool _addedNewRecord = false;

  @override
  void initState() {
    super.initState();
    recordStreamController.addStream(_clubsService.getClubRecords().asStream()).then((value) => setState(() {
          _isLoadingRecords = false;
        }));
  }

  Widget _buildServiceRecord(BuildContext context, QueryDocumentSnapshot<IClubRecord> data) {
    final serviceRecord = data.data();

    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ClubRecord(
            record: serviceRecord,
            onShare: (Uint8List pngBytes, String type) async {
              final String result = await igShareChannel.invokeMethod(type, pngBytes);
              debugPrint(result);
            }));
  }

  Widget _buildRecordsListView(BuildContext context, List<QueryDocumentSnapshot<IClubRecord>> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildServiceRecord(context, data)).toList(),
    );
  }

  Widget _buildRecords() {
    return StreamBuilder<QuerySnapshot<IClubRecord>>(
      stream: recordStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return _buildRecordsListView(context, snapshot.data!.docs);
      },
    );
  }

  Future<void> refreshRecords() async {
    setState(() {
      _isLoadingRecords = true;
    });
    debugPrint("Reloading Records");
    await Future.delayed(const Duration(milliseconds: 500));
    await _clubsService.getClubRecords().then((value) {
      debugPrint("Successfully Reloaded Records");
      recordStreamController.add(value);
    }).whenComplete(() => setState(() {
          _isLoadingRecords = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Club Fragment"),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const ServiceFragment(),
              const SizedBox(height: 15),
              FragmentsButton(
                  type: FragmentsButtonType.gradient,
                  label: "Record New Club",
                  onTap: () async {
                    final update = await Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => const CreateClubScreen()));

                    if (!context.mounted || !update) return;
                    setState(() {
                      _addedNewRecord = true;
                    });
                    await refreshRecords();
                  }),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Club Records",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_isLoadingRecords) return;
                      HapticFeedback.selectionClick();
                      await refreshRecords();
                    },
                    child: _isLoadingRecords
                        ? const CupertinoActivityIndicator()
                        : const Icon(
                            CupertinoIcons.arrow_clockwise,
                            size: 25,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(child: _buildRecords())
            ],
          ),
        )));
  }
}
