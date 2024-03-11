import 'package:cloud_firestore/cloud_firestore.dart';

class IServiceRecord {
  final String organization;
  final String description;
  final int minutesServed;
  final DateTime dateOfService;

  IServiceRecord({
    required this.organization,
    required this.description,
    required this.minutesServed,
    required this.dateOfService,
  });

  factory IServiceRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return IServiceRecord(
      organization: data?['organization'],
      description: data?['description'],
      minutesServed: data?['minutesServed'],
      dateOfService: (data?['dateOfService'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "organization": organization,
      "description": description,
      "minutesServed": minutesServed,
      "dateOfService": dateOfService,
    };
  }
}
