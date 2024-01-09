import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';

class ChatServices extends ChangeNotifier {
  //getting the instance of the user and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sending msgs
  Future<void> sendMessage(String receiverId, String message) async {
    //get the current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );
    //contruct chat room id from current user id and receiver id (sorted to insure uniquness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort the ids (to ensure that it will be same for both that person)
    String chatRoomId = ids.join("_"); //combine the ids into single
    //add new message to database

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //retrieving msgs
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //get the chat room id
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
