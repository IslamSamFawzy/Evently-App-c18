import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseAuthUtils {

  static Future<void> signUpWithEmailAndPassword(
    String emailAddress,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      
      // Update user profile with display name
      await userCredential.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message ?? "");
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        return false;
      }
    }
    return false;
  }
}
