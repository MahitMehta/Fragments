import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/api/services/sports.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/datepicker.dart';
import 'package:gradebook/widgets/text_input.dart';

class CreateSportsScreen extends StatefulWidget {
  const CreateSportsScreen({super.key});

  @override
  State<CreateSportsScreen> createState() => _CreateSportsScreenState();
}

class _CreateSportsScreenState extends State<CreateSportsScreen> {
  final TextEditingController _sportNameController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _performanceController = TextEditingController();
  final SportsService _sportsService = SportsService();

  final GlobalKey<_CreateSportsScreenState> globalKey = GlobalKey();

  String _sportName = "";
  String _event = "";
  String _performance = "";
  DateTime _dateOfRecord = DateTime.now();
  bool _addingRecord = false;

  @override
  void initState() {
    super.initState();
    _sportNameController.addListener(() {
      setState(() {
        _sportName = _sportNameController.text;
      });
    });
    _performanceController.addListener(() {
      setState(() {
        _performance = _performanceController.text;
      });
    });
    _eventController.addListener(() {
      setState(() {
        _event = _eventController.text;
      });
    });
  }

  @override
  void dispose() {
    _sportNameController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  Future addRecord() async {
    setState(() {
      _addingRecord = true;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    await _sportsService.addSportsRecord(_sportName, _event, _dateOfRecord, _performance).then((value) {
      setState(() {
        _addingRecord = false;
      });
      Navigator.pop(context, true);
    }).onError((error, stackTrace) {
      setState(() {
        _addingRecord = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Record Personal Record"),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: SvgPicture.asset(
                      "assets/svg/sports_two.svg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FragmentTextInput(
                    controller: _sportNameController,
                    placeholder: "Sport Name",
                    icon: CupertinoIcons.building_2_fill,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 10),
                  FragmentTextInput(
                    controller: _eventController,
                    placeholder: "Event / Brief Description",
                    icon: CupertinoIcons.textbox,
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 10),
                  FragmentsDatePicker(
                    label: "Date of Record",
                    dateTime: _dateOfRecord,
                    mode: FragmentsDatePickerType.date,
                    onDateTimeChanged: (dateTime) {
                      debugPrint(dateTime.toString());
                      setState(() {
                        _dateOfRecord = dateTime;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  FragmentTextInput(
                    controller: _performanceController,
                    placeholder: "Performance",
                    icon: CupertinoIcons.chart_bar,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 15),
                  FragmentsButton(
                      disabled: _sportName.isEmpty || _event.isEmpty || _performance.isEmpty,
                      type: FragmentsButtonType.gradient,
                      label: "Record Personal Record",
                      loading: _addingRecord,
                      onTap: addRecord),
                ],
              ),
            ))));
  }
}
