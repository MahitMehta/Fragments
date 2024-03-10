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

  Future addServiceRecord(
    String organization,
    String description, 
    Duration hoursServed, 
    DateTime dateOfService
  ) async {
    final IServiceRecord serviceRecord = IServiceRecord(
      organization: organization,
      description: description,
      minutesServed: hoursServed.inMinutes,
      dateOfService: dateOfService,
    );
   
    await _firestore.collection(_getCollectionPath())
    .withConverter(
      fromFirestore: IServiceRecord.fromFirestore,
      toFirestore: (IServiceRecord serviceRecord, options) => serviceRecord.toFirestore(),
    )
    .add(serviceRecord).then((documentSnapshot) =>
      debugPrint("Added Data with ID: ${documentSnapshot.id}")
    );
  }

  Stream<QuerySnapshot<IServiceRecord>> getServiceRecords() {
    return _firestore.collection(_getCollectionPath())
    .withConverter(
      fromFirestore: IServiceRecord.fromFirestore,
      toFirestore: (IServiceRecord serviceRecord, options) => serviceRecord.toFirestore(),
    )
    .get().asStream();
  }
}