import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthHandler {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String _getTemporaryPassword() {
      String tempPassword = "";

      final random = Random.secure();
      const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      for (var i = 0; i < 8; i++) {
        tempPassword += chars[random.nextInt(chars.length)];
      }

      return tempPassword;
  }

  Future<User> handleTemporarySignUp(email) async {
    String tempPassword = _getTemporaryPassword();

    UserCredential result = await auth
    .createUserWithEmailAndPassword(
        email: email, password: tempPassword);
    final User user = result.user!;

    return user;
  }
}