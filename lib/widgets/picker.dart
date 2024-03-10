import 'package:flutter/cupertino.dart';

class Picker extends StatefulWidget {
  const Picker({super.key, required this.onChanged, required this.items, required this.label});

  final void Function(int) onChanged;
  final List<String> items;
  final String label;

@override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color.fromARGB(255, 52, 52, 52),
            fontSize: 15
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 235,
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 15, 15, 15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color.fromARGB(255, 32, 32, 32),
              width: 1
            )
          ),
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
              widget.onChanged(index);
            },
            children: [
              for (var item in widget.items) Text(item)
            ],
          ),
        )
      ],
    );
  }
}