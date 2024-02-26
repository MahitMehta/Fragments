import 'package:flutter/cupertino.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:gradebook/screens/login_screen.dart';

// import 'package:http/http.dart' as http;

// Future getCookie() async {
//      final headers = {
//       "Content-Type": "application/x-www-form-urlencoded",
//       "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
//     };

//     final body = <String, String>{};
//     body["j_username"] = "sonal_akp@yahoo.com";
//     body["j_password"] = "jan21";
//     body["idTokenString"] = "";

//     final response = await http
//         .post(
//             Uri.parse("https://parents.sbschools.org/genesis/j_security_check"),
//             headers: headers,
//             body: body
//           )
//         .catchError((e) {
//       debugPrint(e);
//     });

//     debugPrint(response.request?.headers.toString());
//     debugPrint(response.request?.method.toString());
//   }

 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: "Fragments",
      theme: CupertinoThemeData(
        brightness: Brightness.dark, 
      ),
      home: LoginScreen(),
    );
  }
}