import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/sport.dart';

class SportsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = "sports_records";

  String _getCollectionPath() {
    return "users/${_auth.currentUser!.uid}/$_collectionName";
  }

  Future addSportsRecord(String sportName, String event, DateTime dateOfRecord, String performance) async {
    final ISportRecord clubRecord = ISportRecord(
      sportName: sportName,
      event: event,
      performance: performance,
      dateOfRecord: dateOfRecord,
    );

    await _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: ISportRecord.fromFirestore,
          toFirestore: (ISportRecord clubRecord, options) => clubRecord.toFirestore(),
        )
        .add(clubRecord)
        .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<QuerySnapshot<ISportRecord>> getSportsRecords() {
    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: ISportRecord.fromFirestore,
          toFirestore: (ISportRecord clubRecord, options) => clubRecord.toFirestore(),
        )
        .get();
  }
}
