import 'dart:typed_data';

import 'package:ayusharks/constants/utils.dart';
import 'package:ayusharks/model/investor.dart';
import 'package:ayusharks/model/succesful_start_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database_services.dart';

class InvestorServices extends ChangeNotifier {
  // getting the instance from db
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // creating instance
  Future<void> createInvestorWithSuccess({
    required BuildContext context,
    String? id,
    required Uint8List images,
    required String stage,
    required String industry,
    required String state,
    required String city,
    required String linkedIn,
    required String investorname,
    required String pancard,
    required double budget,
    required String brief,
    required String mobileno,
    required String type,
    required String startUpName,
    required Uint8List startUpImage,
    required int investedAmount,
    required int profit,
    required String startupLink,
    required String investorType,
    required String sector,
    required String intrest,
    required String role,
  }) async {
    // get the current user info

    try {
      // create a new instance of the Investor

      String imageUrl =
          await DatabaseServices().uploadImage('profilePics', images);

      String startUpId = await createStartUp(
        startUpName: startUpName,
        startUpLogo: startUpImage,
        profit: profit,
        investment: investedAmount,
        startUpLink: startupLink,
      );
      List<String> map = [startUpId];
      Investor newInvestor = Investor(
        id: id,
        stage: stage,
        industry: industry,
        state: state,
        city: city,
        linkedIn: linkedIn,
        haveStories: map,
        images: imageUrl,
        investorname: investorname,
        pancard: pancard,
        budget: budget,
        brief: brief,
        mobileno: mobileno,
        type: type,
        investorType: investorType,
        sector: sector,
        intrest: intrest,
        role: role,
      );

      if (id != null) {
        await _firestore
            .collection('investor')
            .doc(id)
            .set(newInvestor.toMap());
      } else {
        // Add a new document with auto-generated ID
        await _firestore.collection('investor').add(newInvestor.toMap());
      }
    } catch (e) {
      showSnackBar(context, "Error Occurred");
    }
  }

  Future<void> createInvestor({
    required BuildContext context,
    String? id,
    required Uint8List images,
    required String stage,
    required String industry,
    required String state,
    required String city,
    required String linkedIn,
    required String investorname,
    required String pancard,
    required double budget,
    required String brief,
    required String mobileno,
    required String type,
    required String investorType,
    required String sector,
    required String intrest,
    required String role,
  }) async {
    // get the current user info

    try {
      // create a new instance of the Investor
      String imageUrl =
          await DatabaseServices().uploadImage('profilePics', images);

      Investor newInvestor = Investor(
        id: id,
        stage: stage,
        industry: industry,
        state: state,
        city: city,
        linkedIn: linkedIn,
        images: imageUrl,
        investorname: investorname,
        pancard: pancard,
        budget: budget,
        brief: brief,
        mobileno: mobileno,
        type: type,
        investorType: investorType,
        sector: sector,
        intrest: intrest,
        role: role,
      );

      if (id != null) {
        await _firestore
            .collection('investor')
            .doc(id)
            .set(newInvestor.toMap());
      } else {
        // Add a new document with auto-generated ID
        await _firestore.collection('investor').add(newInvestor.toMap());
      }
    } catch (e) {
      showSnackBar(context, "Error Occurred");
    }
  }

  Future<String> createStartUp(
      {String? id,
      required String startUpName,
      required Uint8List startUpLogo,
      required int profit,
      required int investment,
      required String startUpLink}) async {
    String imageUrl =
        await DatabaseServices().uploadImage('profilePics', startUpLogo);

    SuccessfulStartUp newStartUp = SuccessfulStartUp(
        startupName: startUpName,
        startUpLogo: imageUrl,
        profit: profit,
        investment: investment,
        startupLink: startUpLink);
    if (id != null) {
      await _firestore
          .collection('successfulStartup')
          .doc(id)
          .set(newStartUp.toMap());

      return id;
    } else {
      // Add a new document with auto-generated ID
      DocumentReference newDocRef = await _firestore
          .collection('successfulStartup')
          .add(newStartUp.toMap());

      // Return the auto-generated ID
      return newDocRef.id;
    }
  }

  Future<Investor?> getInvestorById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('investor').doc(id).get();

      if (documentSnapshot.exists) {
        return Investor.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return throw ErrorDescription(
            "Error Occured"); // Document with the specified ID does not exist
      }
    } catch (e) {
      // Handle error
      return throw ErrorDescription(e.toString());
    }
  }

  Future<List<Investor>> getAllInvestors() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Investor').get();

      List<Investor> investors = querySnapshot.docs.map((doc) {
        return Investor.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return investors;
    } catch (e) {
      return [];
    }
  }
}
