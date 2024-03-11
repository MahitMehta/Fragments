import 'package:flutter/cupertino.dart';

class PeriodOption extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const PeriodOption({super.key, required this.label, required this.onTap, required this.isSelected});

  @override
  State<PeriodOption> createState() => _PeriodOptionState();
}

class _PeriodOptionState extends State<PeriodOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
      height: 25,
      width: 30,
      decoration: BoxDecoration(
        color: widget.isSelected ? null : const Color.fromARGB(255, 29, 29, 29),
        gradient: widget.isSelected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.mirror,
                colors: [
                  Color.fromARGB(255, 154, 106, 255),
                  Color.fromARGB(255, 239, 192, 23),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          widget.label,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
        ),
      ),
    ));
  }
}
