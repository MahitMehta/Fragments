import 'package:flutter/cupertino.dart';
import 'package:gradebook/widgets/period_option.dart';
import 'package:gradebook/widgets/weekly_graph.dart';

class ServiceFragment extends StatefulWidget {
  const ServiceFragment({super.key});

  @override
  State<ServiceFragment> createState() => _ServiceFragmentState();
}

class _ServiceFragmentState extends State<ServiceFragment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const WeeklyGraph()
        ],
      ),
    );
  }
}
