import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../database_services.dart';

class AuthService extends ChangeNotifier {
  //creating instance of the firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //creating new instance for firestore to store msgs
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in method
  Future signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out method
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false, false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserTypeSF("");
      await _firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  //sign up method
  Future signUpUserWithCredentials(
      String fullName, String email, String password, String userType) async {
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseServices(uid: user.uid)
            .savingUserData(fullName, email, userType);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
