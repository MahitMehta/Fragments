import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/api/models/score.dart';
import 'package:gradebook/api/services/score.dart';
import 'package:gradebook/screens/create_score_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/empty_record.dart';
import 'package:gradebook/widgets/score_record.dart';
import 'package:gradebook/widgets/sport_record.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  static const igShareChannel = MethodChannel('com.mahitm.fragments/igShare');
  final ScoreService _scoreService = ScoreService();

  StreamController<QuerySnapshot<IScoreRecord>> recordStreamController = StreamController();
  bool _isLoadingRecords = true;
  bool _addedNewRecord = false;

  @override
  void initState() {
    super.initState();
    recordStreamController.addStream(_scoreService.getScoreRecords().asStream()).then((value) => setState(() {
          _isLoadingRecords = false;
        }));
  }

  Widget _buildServiceRecord(BuildContext context, QueryDocumentSnapshot<IScoreRecord> data) {
    final scoreRecord = data.data();

    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ScoreRecord(
            record: scoreRecord,
            onShare: (Uint8List pngBytes, String type) async {
              final String result = await igShareChannel.invokeMethod(type, pngBytes);
              debugPrint(result);
            }));
  }

  Widget _buildRecordsListView(BuildContext context, List<QueryDocumentSnapshot<IScoreRecord>> snapshot) {
    if (snapshot.isEmpty) {
      return const EmptyRecord();
    }

    return ListView(
      children: snapshot.map((data) => _buildServiceRecord(context, data)).toList(),
    );
  }

  Widget _buildRecords() {
    return StreamBuilder<QuerySnapshot<IScoreRecord>>(
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
    await _scoreService.getScoreRecords().then((value) {
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
          middle: Text("Scores Fragment"),
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
                  label: "Record New Score",
                  onTap: () async {
                    final update = await Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => const CreateScoreScreen()));

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
                    "Score Records",
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
