import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/api/models/service_record.dart';
import 'package:gradebook/api/services/service.dart';
import 'package:gradebook/screens/create_service_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/service_record.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  static const igShareChannel = MethodChannel('com.mahitm.fragments/igShare');
  final ServicesService _servicesService = ServicesService();

  Widget _buildServiceRecord(BuildContext context, QueryDocumentSnapshot<IServiceRecord> data) {
    final serviceRecord = data.data();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ServiceRecord(
        record: serviceRecord,
        onShare: (Uint8List pngBytes) async {
           final String result = await igShareChannel.invokeMethod("SHARE", pngBytes);
           debugPrint(result);
        }
      )
    );
  }

  Widget _buildRecordsListView(BuildContext context, List<QueryDocumentSnapshot<IServiceRecord>> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildServiceRecord(context, data)).toList(),
    );
  }

  Widget _buildRecords() {
    return StreamBuilder<QuerySnapshot<IServiceRecord>>(
      stream: _servicesService.getServiceRecords(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return _buildRecordsListView(context, snapshot.data!.docs);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Service Fragment"),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const ServiceFragment(),
              const SizedBox(height: 15),
              FragmentsButton(
                type: FragmentsButtonType.gradient,
                label: "Record New Service",
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const CreateServiceScreen()
                    )
                  );
                }
              ),
              const SizedBox(height: 25),
              const Text(
                "Service Records",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 30
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _buildRecords()
              )
            ],
          ),
        )
      )
    );
  }
}