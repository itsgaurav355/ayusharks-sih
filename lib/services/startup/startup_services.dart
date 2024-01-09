import 'dart:typed_data';

import 'package:ayusharks/constants/utils.dart';
import 'package:ayusharks/model/startup_user.dart';
import 'package:ayusharks/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartupServices extends ChangeNotifier {
  //getting the instance from db
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //creating instance
  Future<void> createStartup({
    required BuildContext context,
    required Uint8List image,
    required String? id,
    required String companyname,
    required int investement,
    required double profitmargin,
    required double equity,
    required String cin,
    required double revenue,
    required String description,
    required String stage,
    required String msmeNumber,
    required String industry,
    required String sector,
    required String servicesType,
  }) async {
    // get the current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    String imageUrl =
        await DatabaseServices().uploadImage('profilePics', image);
    // String imageUrl = image.toString();
    try {
      //create new instance of the Startup
      StartUp newStartUp = StartUp(
          id: currentUserId,
          images: imageUrl,
          companyName: companyname,
          investement: investement,
          profitmargin: profitmargin,
          equity: equity,
          cin: cin,
          revenue: revenue,
          description: description,
          stage: stage,
          msmeNumber: msmeNumber,
          industry: industry,
          sector: sector,
          servicesType: servicesType);
      // Check if the document already exists
      if (id != null) {
        await _firestore.collection('startup').doc(id).set(newStartUp.toMap());
      } else {
        // Add a new document with auto-generated ID
        await _firestore.collection('startup').add(newStartUp.toMap());
      }
    } catch (e) {
      showSnackBar(context, "Error Occurred");
    }
  }

  // Other methods...

  Future<StartUp?> getStartupById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('startup').doc(id).get();

      if (documentSnapshot.exists) {
        return StartUp.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return throw ErrorDescription(
            "Error Occured"); // Document with the specified ID does not exist
      }
    } catch (e) {
      // Handle error
      return throw ErrorDescription("Error Occured");
    }
  }

  Future<List<StartUp>> getAllStartups() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('startup').get();

      List<StartUp> startups = querySnapshot.docs.map((doc) {
        return StartUp.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return startups;
    } catch (e) {
      // print("Error Occured");
      return [];
    }
  }
  // Other methods...
}
