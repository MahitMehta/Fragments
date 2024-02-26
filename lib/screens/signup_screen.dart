import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/screens/login_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  String email = ""; 
  bool validEmailAddress = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      email = _emailController.text;
    });
  }

  bool validateEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(padding: const EdgeInsets.all(20.0),
          child: Column(
            children: 
              <Widget>[
               Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset( 
                      "assets/svg/logo.svg", 
                      semanticsLabel: 'Logo', 
                      height: 100, 
                      width: 270, 
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Capture Your Fragments',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 25
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                          ) 
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log in.",
                            style: TextStyle(
                              color: Colors.white, // Color.fromARGB(255, 177, 177, 177),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    AnimatedOpacity(
                      opacity: email.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            validEmailAddress ? CupertinoIcons.check_mark_circled : CupertinoIcons.xmark_circle,
                            color: validEmailAddress ? Colors.green : Colors.red
                          ),
                          const SizedBox(width: 5),
                          Text(
                            validEmailAddress ? "Valid email" : "Invalid email", 
                            style: TextStyle(
                              color: validEmailAddress ? Colors.green : Colors.red
                            )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    FragmentTextInput(
                      placeholder: "email address",
                      icon: CupertinoIcons.envelope,
                      controller: _emailController,
                      onEditingComplete: () => {
                        setState(() {
                          validEmailAddress = validateEmail();
                        })
                      },
                    ),
                    const SizedBox(height: 15),
                    FragmentsButton(
                      label: "Verify email address",
                      disabled: !validEmailAddress,
                      type: FragmentsButtonType.gradient,
                      onTap: () {
                        debugPrint("Login button pressed");
                      }  
                    ),
                    const SizedBox(height: 35),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 1,
                          color: const Color.fromARGB(255, 30, 30, 30),
                        ),
                        Positioned(
                          width: 50,
                          height: 20,
                          left: (MediaQuery.of(context).size.width - 40) / 2 - 25,
                          top: -10,
                          child: Center(
                            child: Container(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 52, 52, 52),
                                  ),
                                ),
                              ),
                            )
                          )
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        Expanded(child: 
                          FragmentsButton(
                            image: const AssetImage("assets/icons/apple.png"),
                            onTap: () {
                              debugPrint("Apple button pressed");
                            }
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: 
                          FragmentsButton(
                            image: const AssetImage("assets/icons/google.png"),
                            onTap: () {
                              debugPrint("Google button pressed");
                            }
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "I accept the ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 52, 52, 52),
                    fontSize: 15
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        decoration: TextDecoration.underline
                      ),
                    ),
                    TextSpan(
                      text: " and "
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        decoration: TextDecoration.underline
                      ),
                    ),
                    TextSpan(
                      text: " of Fragments by proceeding.",
                    ),
                  ],
                )
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
    );
  }
}