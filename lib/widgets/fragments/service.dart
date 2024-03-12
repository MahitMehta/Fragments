import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/api/models/service_record.dart';
import 'package:gradebook/api/services/service.dart';
import 'package:gradebook/widgets/icon_button.dart';
import 'package:gradebook/widgets/period_option.dart';
import 'package:gradebook/widgets/weekly_graph.dart';

class ServiceFragment extends StatefulWidget {
  const ServiceFragment({super.key});

  @override
  State<ServiceFragment> createState() => _ServiceFragmentState();
}

class _ServiceFragmentState extends State<ServiceFragment> {
  final ServicesService _servicesService = ServicesService();
  final StreamController<QuerySnapshot<IServiceRecord>> recordStreamController = StreamController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    recordStreamController.addStream(_servicesService.getWeeklyService().asStream());
  }

  void refreshWeeklyChart() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    _servicesService.getWeeklyService().then((value) {
      recordStreamController.add(value);
    }).whenComplete(() => setState(() {
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PeriodOption(label: "W", onTap: () {}, isSelected: true),
                  const SizedBox(width: 10),
                  PeriodOption(label: "M", onTap: () {}, isSelected: false),
                  const SizedBox(width: 10),
                  PeriodOption(label: "Y", onTap: () {}, isSelected: false)
                ],
              ),
              Positioned(
                  right: 5,
                  top: 0,
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: _isLoading
                          ? const CupertinoActivityIndicator()
                          : FragmentsIconButton(
                              onTap: () {
                                refreshWeeklyChart();
                              },
                              icon:
                                  const Icon(CupertinoIcons.arrow_clockwise, color: Color.fromARGB(255, 255, 255, 255)),
                            ))),
            ],
          ),
          WeeklyGraph(
            recordStreamController: recordStreamController,
          )
        ],
      ),
    );
  }
}
