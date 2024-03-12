import 'package:cloud_firestore/cloud_firestore.dart';

class IScoreRecord {
  final String scoreTitle;
  final double yourScore;
  final double maxScore;
  final DateTime dateOfScore;

  IScoreRecord({
    required this.scoreTitle,
    required this.yourScore,
    required this.maxScore,
    required this.dateOfScore,
  });

  factory IScoreRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return IScoreRecord(
      scoreTitle: data?['scoreTitle'],
      yourScore: data?['yourScore'],
      maxScore: data?['maxScore'],
      dateOfScore: (data?['dateOfScore'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "scoreTitle": scoreTitle,
      "yourScore": yourScore,
      "maxScore": maxScore,
      "dateOfScore": dateOfScore,
    };
  }
}
