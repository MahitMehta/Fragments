import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/api/models/sport.dart';
import 'package:gradebook/api/services/sports.dart';
import 'package:gradebook/screens/create_sports_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/empty_record.dart';
import 'package:gradebook/widgets/sport_record.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  static const igShareChannel = MethodChannel('com.mahitm.fragments/igShare');
  final SportsService _sportsService = SportsService();

  StreamController<QuerySnapshot<ISportRecord>> recordStreamController = StreamController();
  bool _isLoadingRecords = true;
  bool _addedNewRecord = false;

  @override
  void initState() {
    super.initState();
    recordStreamController.addStream(_sportsService.getSportsRecords().asStream()).then((value) => setState(() {
          _isLoadingRecords = false;
        }));
  }

  Widget _buildServiceRecord(BuildContext context, QueryDocumentSnapshot<ISportRecord> data) {
    final sportRecord = data.data();

    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: SportRecord(
            record: sportRecord,
            onShare: (Uint8List pngBytes, String type) async {
              final String result = await igShareChannel.invokeMethod(type, pngBytes);
              debugPrint(result);
            }));
  }

  Widget _buildRecordsListView(BuildContext context, List<QueryDocumentSnapshot<ISportRecord>> snapshot) {
    if (snapshot.isEmpty) {
      return const EmptyRecord();
    }

    return ListView(
      children: snapshot.map((data) => _buildServiceRecord(context, data)).toList(),
    );
  }

  Widget _buildRecords() {
    return StreamBuilder<QuerySnapshot<ISportRecord>>(
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
    await _sportsService.getSportsRecords().then((value) {
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
          middle: Text("Sports Fragment"),
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
                  label: "Record New Personal Record",
                  onTap: () async {
                    final update = await Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => const CreateSportsScreen()));

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
                    "Sports Records",
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
