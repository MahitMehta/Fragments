import 'package:flutter/cupertino.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Fragments Privacy"),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: ListView(
          children: const [
            Text(
              "Privacy Policy",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We are Fragments ("Company," "we," "us," "our"), a company registered in New Jersey, United States at 101 Manning Court, South Brunswick Township, NJ 08852.',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We operate the mobile application Fragments (the "App"), as well as any other related products and services that refer or link to these legal terms (the "Legal Terms") (collectively, the "Services").',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Fragments is a mobile application that allows students to document and share different aspects of their high school career such as, but not limited to, community service hours, academic achievements, clubs/organizations, etc. You can contact us by phone at 7328220795, email at fragments@mahitm.com, or by mail to 101 Manning Court, South Brunswick Township, NJ 08852, United States.',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ("you"), and Fragments, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We will provide you with prior notice of any scheduled changes to the Services you are using. The modified Legal Terms will become effective upon posting or notifying you by fragments-noreply@mahitm.com, as stated in the email message. By continuing to use the Services after the effective date of any changes, you agree to be bound by the modified terms.',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'The Services are intended for users who are at least 13 years of age. All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Services. If you are a minor, you must have your parent or guardian read and agree to these Legal Terms prior to you using the Services.',
              style: TextStyle(
                color: Color.fromARGB(255, 177, 177, 177),
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
