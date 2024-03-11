import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/widget.dart';

class WidgetsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = "widgets";

  String _getCollectionPath() {
    return "users/${_auth.currentUser!.uid}/$_collectionName";
  }

  Future addWidget(String name) async {
    final Map<String, dynamic> data = {
      "name": name.toLowerCase(),
    };

    await _firestore
        .collection(_getCollectionPath())
        .add(data)
        .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<QuerySnapshot<IWidget>> getWidgets() {
    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IWidget.fromFirestore,
          toFirestore: (IWidget serviceRecord, options) => serviceRecord.toFirestore(),
        )
        .get();
  }

  Future<void> deleteWidget(String id) async {
    await _firestore.collection(_getCollectionPath()).doc(id).delete();
  }
}
