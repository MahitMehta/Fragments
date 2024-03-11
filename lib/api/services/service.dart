import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/service_record.dart';

class ServicesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collectionName = "service_records";

  String _getCollectionPath() {
    return "users/${_auth.currentUser!.uid}/$_collectionName";
  }

  Future addServiceRecord(String organization, String description, Duration hoursServed, DateTime dateOfService) async {
    final IServiceRecord serviceRecord = IServiceRecord(
      organization: organization,
      description: description,
      minutesServed: hoursServed.inMinutes,
      dateOfService: dateOfService,
    );

    await _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IServiceRecord.fromFirestore,
          toFirestore: (IServiceRecord serviceRecord, options) => serviceRecord.toFirestore(),
        )
        .add(serviceRecord)
        .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<QuerySnapshot<IServiceRecord>> getServiceRecords() {
    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IServiceRecord.fromFirestore,
          toFirestore: (IServiceRecord serviceRecord, options) => serviceRecord.toFirestore(),
        )
        .orderBy("dateOfService", descending: true)
        .get();
  }

  Future<QuerySnapshot<IServiceRecord>> getWeeklyService() {
    final DateTime now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(
      days: 6,
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    ));

    return _firestore
        .collection(_getCollectionPath())
        .withConverter(
          fromFirestore: IServiceRecord.fromFirestore,
          toFirestore: (IServiceRecord serviceRecord, options) => serviceRecord.toFirestore(),
        )
        .where("dateOfService", isGreaterThanOrEqualTo: startOfWeek)
        .where("dateOfService", isLessThanOrEqualTo: now)
        .get();
  }
}
