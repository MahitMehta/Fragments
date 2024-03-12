import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/score.dart';
import 'package:gradebook/api/models/sport.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = "score_records";

  String _getCollectionPath() {
    return "users/${_auth.currentUser!.uid}/$_collectionName";
  }

  Future addScoreRecord(String scoreTitle, String yourScore, String maxScore, DateTime dateOfScore) async {
    final IScoreRecord scoreRecord = IScoreRecord(
      scoreTitle: scoreTitle,
      yourScore: double.parse(yourScore),
      maxScore: double.parse(maxScore),
      dateOfScore: dateOfScore,
    );

    await _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IScoreRecord.fromFirestore,
          toFirestore: (IScoreRecord scoreRecord, options) => scoreRecord.toFirestore(),
        )
        .add(scoreRecord)
        .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<QuerySnapshot<IScoreRecord>> getScoreRecords() {
    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IScoreRecord.fromFirestore,
          toFirestore: (IScoreRecord scoreRecord, options) => scoreRecord.toFirestore(),
        )
        .get();
  }
}
