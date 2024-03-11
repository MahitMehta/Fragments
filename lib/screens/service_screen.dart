import 'dart:async';

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

  StreamController<QuerySnapshot<IServiceRecord>> recordStreamController = StreamController();
  bool _isLoadingRecords = true;
  bool _addedNewRecord = false;

  @override
  void initState() {
    super.initState();
    recordStreamController.addStream(_servicesService.getServiceRecords().asStream()).then((value) => setState(() {
          _isLoadingRecords = false;
        }));
  }

  Widget _buildServiceRecord(BuildContext context, QueryDocumentSnapshot<IServiceRecord> data) {
    final serviceRecord = data.data();

    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ServiceRecord(
            record: serviceRecord,
            onShare: (Uint8List pngBytes, String type) async {
              final String result = await igShareChannel.invokeMethod(type, pngBytes);
              debugPrint(result);
            }));
  }

  Widget _buildRecordsListView(BuildContext context, List<QueryDocumentSnapshot<IServiceRecord>> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildServiceRecord(context, data)).toList(),
    );
  }

  Widget _buildRecords() {
    return StreamBuilder<QuerySnapshot<IServiceRecord>>(
      stream: recordStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return _buildRecordsListView(context, snapshot.data!.docs);
      },
    );
  }

  Future<void> refreshRecords() async {
    setState(() {
      _isLoadingRecords = true;
    });
    debugPrint("Reloading Records");
    await Future.delayed(const Duration(milliseconds: 500));
    await _servicesService.getServiceRecords().then((value) {
      debugPrint("Successfully Reloaded Records");
      recordStreamController.add(value);
    }).whenComplete(() => setState(() {
          _isLoadingRecords = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Service Fragment"),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          // leading: IconButton(
          //   onTap: () {
          //     HapticFeedback.selectionClick();
          //     Navigator.of(context).pop(_addedNewRecord);
          //   },
          //   icon: const Icon(
          //     CupertinoIcons.back, color:
          //     Color.fromARGB(255, 14, 122, 254)
          //   ),
          // ),
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
                  onTap: () async {
                    final update = await Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => const CreateServiceScreen()));

                    if (!context.mounted || !update) return;
                    setState(() {
                      _addedNewRecord = true;
                    });
                    await refreshRecords();
                  }),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Service Records",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 30),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_isLoadingRecords) return;
                      HapticFeedback.selectionClick();
                      await refreshRecords();
                    },
                    child: _isLoadingRecords
                        ? const CupertinoActivityIndicator()
                        : const Icon(
                            CupertinoIcons.arrow_clockwise,
                            size: 25,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(child: _buildRecords())
            ],
          ),
        )));
  }
}
