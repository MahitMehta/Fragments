import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradebook/api/services/auth.dart';
import 'package:gradebook/screens/login_screen.dart';
import 'package:gradebook/screens/main_tab_navigator.dart';
import 'package:gradebook/widgets/button.dart';
import 'package:gradebook/widgets/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  int _currentIndex = 0;

  String _email = "";
  bool _displayEmailStatus = false;
  bool _validEmailAddress = false;
  bool _awaitingVerification = false;
  bool _sentVerification = false;
  bool _emailVerified = false;
  late Timer _emailVerificationPeriodicTimer;

  String _password = "";
  String _confirmPassword = "";
  bool _settingPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _displayEmailStatus = false;
        _email = _emailController.text;
        _validEmailAddress = AuthService.validateEmail(_email);
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        _confirmPassword = _confirmPasswordController.text;
      });
    });
  }

  Future<void> loginWithApple() async {
    final appleProvider = AppleAuthProvider();
    if (kIsWeb) {
      await FirebaseAuth.instance.signInWithPopup(appleProvider).then((value) {
        debugPrint("Logged in with Apple");

        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const MainTabNavigator(),
          ),
        );
      });
    } else {
      await FirebaseAuth.instance.signInWithProvider(appleProvider).then((value) {
        debugPrint("Logged in with Apple");

        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const MainTabNavigator(),
          ),
        );
      });
    }
  }

  Future<void> loginWithGoogle() async {
    debugPrint("Logging in with Google");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      debugPrint("Logged in with Google");

      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => const MainTabNavigator(),
        ),
      );
    }).catchError((error) {
      debugPrint("Failed to log in with Google");
      return error;
    });
  }

  void isEmailVerified(Timer timer) async {
    debugPrint("Checking for email verification");

    await FirebaseAuth.instance.currentUser!.reload().then((value) {
      debugPrint("User reloaded");
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        debugPrint("Email verified");
        timer.cancel();

        setState(() {
          _awaitingVerification = false;
          _emailVerified = true;
          _currentIndex = 1;
        });
      }
    });
  }

  void setPassword() async {
    debugPrint("Setting password");
    setState(() {
      _settingPassword = true;
    });

    await FirebaseAuth.instance.currentUser!.updatePassword(_password).then((value) {
      debugPrint("Password updated");

      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => const MainTabNavigator(),
        ),
      );
    }).catchError((error) {
      debugPrint("Error updating password: $error");
    });

    setState(() {
      _settingPassword = false;
    });
  }

  void sendVerificationEmail() async {
    setState(() {
      _awaitingVerification = true;
    });

    try {
      User user = await _authService.handleTemporarySignUp(_email);
      await user.sendEmailVerification().catchError((error) {
        debugPrint("Error sending email verification: $error");
      });

      debugPrint("Email sent to ${user.email}");
      _emailVerificationPeriodicTimer = Timer.periodic(const Duration(seconds: 2), isEmailVerified);

      setState(() {
        _sentVerification = true;
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          debugPrint("Email already in use");
          break;
        case "invalid-email":
          debugPrint("Invalid email");
          break;
        case "operation-not-allowed":
          debugPrint("Operation not allowed");
          break;
        case "weak-password":
          debugPrint("Weak password");
          break;
        default:
          debugPrint("Unknown error");
      }

      setState(() {
        _awaitingVerification = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    try {
      _emailVerificationPeriodicTimer.cancel();
    } catch (e) {
      // debugPrint("Error cancelling email verification timer: $e");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
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
                const Text('Capture Your Fragments',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w500, fontSize: 25)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                        )),
                    CupertinoButton(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log in.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255), // Color.fromARGB(255, 177, 177, 177),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(primaryAnimation),
                        child: FadeTransition(
                          opacity: Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(primaryAnimation),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: IndexedStack(
                    index: _currentIndex,
                    key: ValueKey<int>(_currentIndex),
                    children: [
                      Column(
                        children: [
                          AnimatedOpacity(
                            opacity: _displayEmailStatus && _email.isNotEmpty ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Icon(
                                  _validEmailAddress ? CupertinoIcons.check_mark_circled : CupertinoIcons.xmark_circle,
                                  //color: _validEmailAddress ? Colors.green : Colors.red
                                ),
                                const SizedBox(width: 5),
                                Text(_validEmailAddress ? "Valid email" : "Invalid email",
                                    style: TextStyle(
                                        color: _validEmailAddress
                                            ? const Color.fromRGBO(76, 175, 80, 1)
                                            : const Color.fromRGBO(244, 67, 54, 1))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          FragmentTextInput(
                            placeholder: "email address",
                            icon: CupertinoIcons.envelope,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onEditingComplete: () => {
                              setState(() {
                                _displayEmailStatus = true;
                              })
                            },
                          ),
                          const SizedBox(height: 15),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            FragmentsButton(
                              label: _emailVerified
                                  ? "Email verified"
                                  : _sentVerification
                                      ? "Email sent & awaiting verification"
                                      : _awaitingVerification
                                          ? "Sending verification email"
                                          : "Send verification email",
                              disabled: !_validEmailAddress || _emailVerified,
                              type: FragmentsButtonType.gradient,
                              loading: _awaitingVerification,
                              onTap: sendVerificationEmail,
                            ),
                            const SizedBox(height: 5),
                            AnimatedOpacity(
                              opacity: _sentVerification ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 250),
                              child: CupertinoButton(
                                minSize: 20,
                                padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  debugPrint("Resend email");
                                },
                                child: const Text(
                                  "Resend email?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 62, 62, 62),
                                  ),
                                ),
                              ),
                            )
                          ]),
                          const SizedBox(height: 25),
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
                                  )))
                            ],
                          ),
                          const SizedBox(height: 35),
                          Row(
                            children: [
                              Expanded(
                                  child: FragmentsButton(
                                image: const AssetImage("assets/icons/apple.png"),
                                onTap: loginWithApple,
                              )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: FragmentsButton(
                                image: const AssetImage("assets/icons/google.png"),
                                onTap: loginWithGoogle,
                              )),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PasswordMeter(
                          //   password: _password,
                          // ),
                          const SizedBox(height: 10),
                          FragmentTextInput(
                            placeholder: "Password",
                            controller: _passwordController,
                            icon: CupertinoIcons.lock_shield,
                            obscureText: true,
                            onEditingComplete: () => {},
                          ),
                          const SizedBox(height: 10),
                          FragmentTextInput(
                            placeholder: "Confirm password",
                            controller: _confirmPasswordController,
                            icon: CupertinoIcons.text_badge_checkmark,
                            obscureText: true,
                            onEditingComplete: () => {},
                          ),
                          const SizedBox(height: 25),
                          FragmentsButton(
                            label: "Set Password",
                            type: FragmentsButtonType.gradient,
                            disabled: _password != _confirmPassword,
                            loading: _settingPassword,
                            onTap: setPassword,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
            const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "I accept the ",
                  style: TextStyle(color: Color.fromARGB(255, 52, 52, 52), fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                      text: " of Fragments by proceeding.",
                    ),
                  ],
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
