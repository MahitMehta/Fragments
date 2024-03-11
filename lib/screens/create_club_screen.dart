import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/api/services/club.dart';
import 'package:gradebook/api/services/service.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/datepicker.dart';
import 'package:gradebook/widgets/text_input.dart';

class CreateClubScreen extends StatefulWidget {
  const CreateClubScreen({super.key});

  @override
  State<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _positionHeldController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ClubService _clubService = ClubService();

  final GlobalKey<_CreateClubScreenState> globalKey = GlobalKey();

  String _organization = "";
  String _positionHeld = "";
  String _description = "";
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _addingRecord = false;

  @override
  void initState() {
    super.initState();
    _organizationController.addListener(() {
      setState(() {
        _organization = _organizationController.text;
      });
    });
    _positionHeldController.addListener(() {
      setState(() {
        _positionHeld = _positionHeldController.text;
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
    await _clubService.addClubRecord(_organization, _positionHeld, _description, _startDate, _endDate).then((value) {
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
          middle: Text("Record Club"),
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
                      "assets/svg/club.svg",
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FragmentTextInput(
                    controller: _organizationController,
                    placeholder: "Club Name",
                    icon: CupertinoIcons.building_2_fill,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 10),
                  FragmentTextInput(
                    controller: _positionHeldController,
                    placeholder: "Position Held",
                    icon: CupertinoIcons.person_crop_square_fill,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 10),
                  FragmentsDatePicker(
                    label: "Start Date",
                    dateTime: _startDate,
                    mode: FragmentsDatePickerType.date,
                    onDateTimeChanged: (dateTime) {
                      debugPrint(dateTime.toString());
                      setState(() {
                        _startDate = dateTime;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  FragmentsDatePicker(
                    label: "End Date",
                    dateTime: _endDate,
                    mode: FragmentsDatePickerType.date,
                    onDateTimeChanged: (dateTime) {
                      debugPrint(dateTime.toString());
                      setState(() {
                        _endDate = dateTime;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  FragmentTextInput(
                    controller: _descriptionController,
                    placeholder: "Brief Description",
                    icon: CupertinoIcons.textbox,
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 15),
                  FragmentsButton(
                      disabled: _organization.isEmpty || _description.isEmpty,
                      type: FragmentsButtonType.gradient,
                      label: "Record Club",
                      loading: _addingRecord,
                      onTap: addRecord),
                ],
              ),
            ))));
  }
}
