import 'package:flutter/cupertino.dart';
import 'package:gradebook/widgets/period_option.dart';

class ServiceFragment extends StatefulWidget {
  const ServiceFragment({super.key});

  @override
  State<ServiceFragment> createState() => _ServiceFragmentState();
}

class _ServiceFragmentState extends State<ServiceFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PeriodOption(
              label: "W",
              onTap: () {},
              isSelected: true
            ),
            const SizedBox(width: 10),
            PeriodOption(
              label: "M",
              onTap: () {},
              isSelected: false
            ),
            const SizedBox(width: 10),
            PeriodOption(
              label: "Y",
              onTap: () {},
              isSelected: false
            )
          ],
        ),
      ],
    );
  }
}