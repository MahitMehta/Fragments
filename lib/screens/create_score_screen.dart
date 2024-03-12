import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/api/services/score.dart';
import 'package:gradebook/api/services/sports.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/datepicker.dart';
import 'package:gradebook/widgets/text_input.dart';

class CreateScoreScreen extends StatefulWidget {
  const CreateScoreScreen({super.key});

  @override
  State<CreateScoreScreen> createState() => _CreateSportsScreenState();
}

class _CreateSportsScreenState extends State<CreateScoreScreen> {
  final TextEditingController _scoreTitleController = TextEditingController();
  final TextEditingController _yourScoreController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();
  final ScoreService _scoreService = ScoreService();

  final GlobalKey<_CreateSportsScreenState> globalKey = GlobalKey();

  String _scoreTitle = "";
  String _yourScore = "";
  String _maxScore = "";
  DateTime _dateOfScore = DateTime.now();
  bool _addingRecord = false;

  @override
  void initState() {
    super.initState();
    _scoreTitleController.addListener(() {
      setState(() {
        _scoreTitle = _scoreTitleController.text;
      });
    });
    _yourScoreController.addListener(() {
      setState(() {
        _yourScore = _yourScoreController.text;
      });
    });
    _maxScoreController.addListener(() {
      setState(() {
        _maxScore = _maxScoreController.text;
      });
    });
  }

  @override
  void dispose() {
    _scoreTitleController.dispose();
    _yourScoreController.dispose();
    _maxScoreController.dispose();

    super.dispose();
  }

  Future addRecord() async {
    setState(() {
      _addingRecord = true;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    await _scoreService.addScoreRecord(_scoreTitle, _yourScore, _maxScore, _dateOfScore).then((value) {
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
          middle: Text("Record Score"),
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
                    controller: _scoreTitleController,
                    placeholder: "Score Title",
                    icon: CupertinoIcons.book,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 10),
                  FragmentsDatePicker(
                    label: "Date of Score",
                    dateTime: _dateOfScore,
                    mode: FragmentsDatePickerType.date,
                    onDateTimeChanged: (dateTime) {
                      debugPrint(dateTime.toString());
                      setState(() {
                        _dateOfScore = dateTime;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FragmentTextInput(
                          controller: _yourScoreController,
                          placeholder: "Your Score",
                          icon: CupertinoIcons.chart_bar,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FragmentTextInput(
                          controller: _maxScoreController,
                          placeholder: "Max Score",
                          icon: CupertinoIcons.chart_bar,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () {},
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  FragmentsButton(
                      disabled: _scoreTitle.isEmpty || _yourScore.isEmpty || _maxScore.isEmpty,
                      type: FragmentsButtonType.gradient,
                      label: "Record Score",
                      loading: _addingRecord,
                      onTap: addRecord),
                ],
              ),
            ))));
  }
}
