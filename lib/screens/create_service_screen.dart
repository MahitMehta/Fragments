import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/api/services/service.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/datepicker.dart';
import 'package:gradebook/widgets/text_input.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key}); 

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ServicesService _servicesService = ServicesService();

  final GlobalKey<_CreateServiceScreenState> globalKey = GlobalKey();

  String _organization = "";
  String _description = "";
  Duration _hoursServed = const Duration(hours: 0, minutes: 0);
  DateTime _dateOfService = DateTime.now();
  bool _addingRecord = false; 

   @override
  void initState() {
    super.initState();
    _organizationController.addListener(() {
      setState(() {
        _organization = _organizationController.text;
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _description = _descriptionController.text;
      });
    });
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future addRecord() async {
    setState(() {
      _addingRecord = true;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    await _servicesService.addServiceRecord(
      _organization,
      _description,
      _hoursServed,
      _dateOfService
    ).then((value) {
      setState(() {
        _addingRecord = false;
      });
      Navigator.pop(context);
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
        middle: Text("Record Service"),
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
                    "assets/svg/clock_outline.svg",
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 25),
                FragmentTextInput(
                  controller: _organizationController,
                  placeholder: "Organization",
                  icon: CupertinoIcons.building_2_fill,
                  keyboardType: TextInputType.name,
                  onEditingComplete: () {
                  },
                ),
                const SizedBox(height: 10),
                FragmentsDatePicker(
                  label: "Hours Served",
                  duration: _hoursServed,
                  mode: FragmentsDatePickerType.time,
                  onTimerDurationChanged: (duration) {
                    debugPrint(duration.toString());
                    setState(() {
                      _hoursServed = duration;
                    });
                  },
                ),
                const SizedBox(height: 10),
                FragmentsDatePicker(
                  label: "Date of Service",
                  dateTime: _dateOfService,
                  mode: FragmentsDatePickerType.date,
                  onDateTimeChanged: (dateTime) {
                    debugPrint(dateTime.toString());
                    setState(() {
                      _dateOfService = dateTime;
                    });
                  },
                ),
                const SizedBox(height: 10),
                 FragmentTextInput(
                  controller: _descriptionController,
                  placeholder: "Brief Description",
                  icon: CupertinoIcons.textbox,
                  keyboardType: TextInputType.text,
                  onEditingComplete: () {
                  },
                ),
                const SizedBox(height: 15),
                FragmentsButton(
                  disabled: _organization.isEmpty ||
                    _description.isEmpty || 
                    _hoursServed.inMinutes == 0,
                  type: FragmentsButtonType.gradient,
                  label: "Record Service",
                  loading: _addingRecord,
                  onTap: addRecord
                ),
                const SizedBox(height: 25),
                const Text(
                  "\"Do small things with great love.\"",
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 30, 30),
                    fontSize: 17,
                    fontStyle: FontStyle.italic
                  ),
                ),
                const Text(
                  "- Mother Teresa",
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 30, 30),
                    fontSize: 17,
                    fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }
}