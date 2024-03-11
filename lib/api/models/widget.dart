import 'package:cloud_firestore/cloud_firestore.dart';

class IWidget {
  final String name;

  IWidget({required this.name});

  factory IWidget.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return IWidget(
      name: data?['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
    };
  }
}
