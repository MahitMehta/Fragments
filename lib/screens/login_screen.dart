import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradebook/screens/signup_screen.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                          "Don't have an account?",
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
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up.",
                            style: TextStyle(
                              color: Colors.white, // Color.fromARGB(255, 177, 177, 177),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const FragmentTextInput(
                          placeholder: "email address",
                          keyboardType: TextInputType.emailAddress,
                          icon: CupertinoIcons.envelope,
                        ),
                        const SizedBox(height: 10),
                        const FragmentTextInput(
                          placeholder: "password",
                          icon: CupertinoIcons.lock_shield,
                          obscureText: true,
                        ),
                        const SizedBox(height: 5),
                        CupertinoButton(
                          minSize: 20,
                          padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            debugPrint("Forgot password button pressed");
                          },
                          child: const Text(        
                            "Forget password?",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 62, 62, 62),
                            ),
                          ),
                        )
                      ]
                    ),
                    const SizedBox(height: 25),
                    FragmentsButton(
                      label: "Log in",
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