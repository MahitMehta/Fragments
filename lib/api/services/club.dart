import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/club.dart';

class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = "club_records";

  String _getCollectionPath() {
    return "users/${_auth.currentUser!.uid}/$_collectionName";
  }

  Future addClubRecord(
      String clubName, String positionHeld, String description, DateTime startDate, DateTime endDate) async {
    final IClubRecord clubRecord = IClubRecord(
      clubName: clubName,
      positionHeld: positionHeld,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );

    await _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IClubRecord.fromFirestore,
          toFirestore: (IClubRecord clubRecord, options) => clubRecord.toFirestore(),
        )
        .add(clubRecord)
        .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<QuerySnapshot<IClubRecord>> getClubRecords() {
    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IClubRecord.fromFirestore,
          toFirestore: (IClubRecord clubRecord, options) => clubRecord.toFirestore(),
        )
        .orderBy("endDate", descending: true)
        .get();
  }
}
