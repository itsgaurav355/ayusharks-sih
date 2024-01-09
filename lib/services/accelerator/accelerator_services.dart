import 'dart:typed_data';
import 'package:ayusharks/constants/utils.dart';
import 'package:ayusharks/model/accelerator.dart';
import 'package:ayusharks/model/succesful_start_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database_services.dart';

class AcceleratorServices extends ChangeNotifier {
  // getting the instance from db
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // creating instance
  Future<void> createAcceleratorWithSuccess({
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
  }) async {
    // get the current user info

    try {
      // create a new instance of the Accelerator

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
      Accelerator newInvestor = Accelerator(
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
      );

      if (id != null) {
        await _firestore
            .collection('accelerator')
            .doc(id)
            .set(newInvestor.toMap());
      } else {
        // Add a new document with auto-generated ID
        await _firestore.collection('accelerator').add(newInvestor.toMap());
      }
    } catch (e) {
      showSnackBar(context, "Error Occurred");
    }
  }

  Future<void> createAccelerator({
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
  }) async {
    // get the current user info

    try {
      // create a new instance of the Accelerator
      String imageUrl =
          await DatabaseServices().uploadImage('profilePics', images);

      Accelerator newInvestor = Accelerator(
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
      );

      if (id != null) {
        await _firestore
            .collection('accelerator')
            .doc(id)
            .set(newInvestor.toMap());
      } else {
        // Add a new document with auto-generated ID
        await _firestore.collection('accelerator').add(newInvestor.toMap());
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

  Future<Accelerator?> getAcceleratorById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('accelerator').doc(id).get();

      if (documentSnapshot.exists) {
        return Accelerator.fromMap(
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

  Future<List<Accelerator>> getAllInvestors() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('accelerator').get();

      List<Accelerator> investors = querySnapshot.docs.map((doc) {
        return Accelerator.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return investors;
    } catch (e) {
      return [];
    }
  }
}
