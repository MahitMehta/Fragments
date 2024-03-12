import 'package:cloud_firestore/cloud_firestore.dart';

class ISportRecord {
  final String sportName;
  final String event;
  final String performance;
  final DateTime dateOfRecord;

  ISportRecord({
    required this.sportName,
    required this.event,
    required this.performance,
    required this.dateOfRecord,
  });

  factory ISportRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ISportRecord(
      sportName: data?['sportName'],
      event: data?['event'],
      performance: data?['performance'],
      dateOfRecord: (data?['dateOfRecord'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "sportName": sportName,
      "event": event,
      "performance": performance,
      "dateOfRecord": dateOfRecord,
    };
  }
}
