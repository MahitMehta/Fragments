import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/service_record.dart';
import 'package:gradebook/widgets/dashed_line.dart';

class WeeklyGraph extends StatefulWidget {
  final StreamController<QuerySnapshot<IServiceRecord>> recordStreamController;

  const WeeklyGraph({
    super.key,
    required this.recordStreamController
  });

  @override
  State<WeeklyGraph> createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<WeeklyGraph> {
  static final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<int> tallyMinutes(List<QueryDocumentSnapshot<IServiceRecord>> snapshots) {
    final List<int> hours = List.filled(7, 0);
    final now = DateTime.now().subtract(
      Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        milliseconds: DateTime.now().millisecond,
        microseconds: DateTime.now().microsecond,
      ),
    );
    for (final QueryDocumentSnapshot<IServiceRecord> snapshot in snapshots) {
      final IServiceRecord record = snapshot.data();
      final recordDOS = record.dateOfService.subtract(Duration(
        hours: record.dateOfService.hour,
        minutes: record.dateOfService.minute,
        seconds: record.dateOfService.second,
        milliseconds: record.dateOfService.millisecond,
        microseconds: record.dateOfService.microsecond,
      ));
      final diff = now.difference(recordDOS);
      final int day = 6 - (diff.inHours / 24).ceil();
      hours[day] += record.minutesServed;
    }

    return hours;
  }

  Widget _buildPopulatedBarGraph(BuildContext context, List<int> talliedMinutes) {
    final avgService = (talliedMinutes.reduce((a, b) => a + b) ~/ 7);
    final maxMinutes = talliedMinutes.reduce(max);
    final maxMinutesAdjusted = maxMinutes > 0 ? maxMinutes : 90;

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 7; i++)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  "${(talliedMinutes[i] ~/ 60).toString().padLeft(2, "0")}:${(talliedMinutes[i] % 60).toString().padLeft(2, "0")}",
                  textAlign: TextAlign.center,
                  softWrap: false,
                  style: const TextStyle(color: Color.fromARGB(255, 52, 52, 52), fontSize: 12),
                ),
              )),
          ],
        ),
        const SizedBox(height: 3),
        Stack(
          children: [
            Row(
              children: [
                for (int i = 0; i < 7; i++)
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 10, 10, 10),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: (talliedMinutes[i] / maxMinutesAdjusted) * 90,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 154, 106, 255),
                                            Color.fromARGB(255, 239, 192, 23),
                                          ] // Color.fromARGB(255, 209, 161, 105)],
                                          ),
                                      border: Border.all(color: const Color.fromARGB(255, 10, 10, 10), width: 3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
              ],
            ),
            Positioned(
              top: avgService == 0 ? 90 - 17 : 90 - (avgService / talliedMinutes.reduce(max)) * 90 - 16,
              child: Text("${(avgService / 60).toStringAsFixed(2)}h AVG",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 52, 52, 52),
                    fontSize: 12,
                  )),
            ),
            Positioned(
                top: avgService == 0 ? 89 : 90 - (avgService / talliedMinutes.reduce(max)) * 90,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  child: const DashLineView(
                    dashColor: Color.fromARGB(255, 52, 52, 52),
                    dashHeight: 1,
                    dashWith: 6,
                    direction: Axis.horizontal,
                    fillRate: 0.5,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildBarGraph() {
    return StreamBuilder<QuerySnapshot<IServiceRecord>>(
      stream: widget.recordStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final talliedMinutes = tallyMinutes(snapshot.data!.docs);
        return _buildPopulatedBarGraph(context, talliedMinutes);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      children: [
        _buildBarGraph(),
        Row(
          children: [
            for (int i = now.weekday - 7; i < now.weekday; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Text(
                    _days[i >= 0 ? i : i + 7],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 52, 52, 52),
                      fontSize: 14,
                    ),
                  ),
                ),
              )
          ],
        )
      ],
    );
  }
}
