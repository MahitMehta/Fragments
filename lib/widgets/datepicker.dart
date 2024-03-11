import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum FragmentsDatePickerType { date, time }

class FragmentsDatePicker extends StatelessWidget {
  final void Function(Duration)? onTimerDurationChanged;
  final void Function(DateTime)? onDateTimeChanged;
  final String label;
  final FragmentsDatePickerType? mode;
  final Duration duration;
  final DateTime? dateTime;

  const FragmentsDatePicker(
      {super.key,
      this.duration = const Duration(hours: 0, minutes: 0),
      this.dateTime,
      this.mode = FragmentsDatePickerType.date,
      this.onTimerDurationChanged,
      this.onDateTimeChanged,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 250,
                color: const Color.fromARGB(255, 0, 0, 0),
                child: mode == FragmentsDatePickerType.date
                    ? CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        maximumDate: DateTime.now().add(const Duration(hours: 1)),
                        onDateTimeChanged: (value) {
                          onDateTimeChanged?.call(value);
                        },
                      )
                    : CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hm,
                        minuteInterval: 5,
                        onTimerDurationChanged: (value) {
                          onTimerDurationChanged?.call(value);
                        },
                      ),
              );
            });
      },
      child: Container(
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: const Color.fromARGB(255, 30, 30, 30),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Icon(
                  mode == FragmentsDatePickerType.time ? CupertinoIcons.time : CupertinoIcons.calendar,
                  color: const Color.fromARGB(255, 30, 30, 30),
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Color.fromARGB(255, 62, 62, 62), fontSize: 17),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  mode == FragmentsDatePickerType.time
                      ? "${duration.inHours}h ${duration.inMinutes.remainder(60)}m"
                      : dateTime != null
                          ? "${dateTime!.month}/${dateTime!.day}/${dateTime!.year}"
                          : "",
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 17),
                ),
              ))
            ],
          )),
    );
  }
}
