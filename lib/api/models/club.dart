import 'package:cloud_firestore/cloud_firestore.dart';

class IClubRecord {
  final String clubName;
  final String positionHeld;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  IClubRecord({
    required this.clubName,
    required this.positionHeld,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory IClubRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return IClubRecord(
      clubName: data?['clubName'],
      positionHeld: data?['positionHeld'],
      description: data?['description'],
      startDate: (data?['startDate'] as Timestamp).toDate(),
      endDate: (data?['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "clubName": clubName,
      "positionHeld": positionHeld,
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
    };
  }
}
