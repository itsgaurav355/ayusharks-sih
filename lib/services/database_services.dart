import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});

  // reference for collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference investorCollection =
      FirebaseFirestore.instance.collection("investor");
  final CollectionReference startupCollection =
      FirebaseFirestore.instance.collection("startup");
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection("connection");

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(String childName, Uint8List file) async {
    Reference ref = storage
        .ref()
        .child(childName)
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('test/$imageName').getDownloadURL();

    return downloadURL;
  }

  //updating the userData
  Future savingUserData(String fullName, String email, String userType) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "connectedWith": [],
      "haveRequest": [],
      "profile": "",
      "uid": uid,
      "usertype": userType
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingStartupData(String id) async {
    QuerySnapshot snapshot =
        await startupCollection.where("id", isEqualTo: id).get();

    return snapshot;
  }

  Future gettingInvestorData(String id) async {
    QuerySnapshot snapshot =
        await investorCollection.where("id", isEqualTo: id).get();
    return snapshot;
  }

  //getting user Groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating new group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    //update the members in db
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  //getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  getConnectionRequest(id) async {
    return connectionCollection.doc(id).snapshots();
  }

  //searching in db for community
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  searchByStartUpName(String startupName) {
    return startupCollection.where("companyname", isEqualTo: startupName).get();
  }

  searchByInvestorName(String investorName) {
    return startupCollection
        .where("investorname", isEqualTo: investorName)
        .get();
  }

  //check whether the user has joined the perticular community or not
  Future<bool> isUSerJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // Function to send a connection request
  Future<void> sendConnectionRequest(String senderId, String receiverId) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(receiverId).collection('requests');

    await receiverRequestsCollection.doc(senderId).set({
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> getConnectionStatus(String startUpId) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(uid).collection('requests');
    DocumentSnapshot docSnapshot =
        await receiverRequestsCollection.doc(startUpId).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      String status = data['status'];
      return status;
    } else {
      return 'not_connected';
    }
  }

  Future<void> updateConnectionStatus(
      String startUpId, String newStatus) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(uid).collection('requests');

    await receiverRequestsCollection.doc(startUpId).set({
      'status': newStatus,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeConnection(String startUpId) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(uid).collection('requests');
    await receiverRequestsCollection.doc(startUpId).delete();
  }

  Future<void> removeConnectionRequest(String startUpId) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(uid).collection('requests');
    await receiverRequestsCollection.doc(startUpId).delete();
  }

  Future<bool> doesConnectionRequestExist(String startUpId) async {
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(uid).collection('requests');
    DocumentSnapshot docSnapshot =
        await receiverRequestsCollection.doc(startUpId).get();

    return docSnapshot.exists;
  }

  Future<List<Map<String, dynamic>>> getAllConnectionRequests(
      String uid) async {
    List<Map<String, dynamic>> connectionRequests = [];

    try {
      // Get a reference to the collection of connection requests
      CollectionReference connectionRequestsCollection =
          connectionCollection.doc(uid).collection('requests');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await connectionRequestsCollection.get();

      // Loop through the documents and add them to the list
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        if (document.exists) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>;

          if (data != null && data.containsKey('status')) {
            Map<String, dynamic> request = {
              'senderId': document.id,
              'status': data['status'],
            };
            connectionRequests.add(request);
          }
        }
      }
    } catch (e) {
      // Handle errors if any
      print('Error fetching connection requests: $e');
    }

    return connectionRequests;
  }

  void acceptConnectionRequest(String senderId) async {
    // Update the status to 'accepted' in the database
    await connectionCollection
        .doc(uid)
        .collection('requests')
        .doc(senderId)
        .update({'status': 'accepted'});
  }

  void rejectConnectionRequest(String senderId) async {
    // Remove the connection request from the database
    await connectionCollection
        .doc(uid)
        .collection('requests')
        .doc(senderId)
        .delete();
  }

  Future<bool> doesConnectionExist(String senderId, String receiverId) async {
    CollectionReference senderRequestsCollection =
        connectionCollection.doc(senderId).collection('requests');
    DocumentSnapshot receiverDocSnapshot =
        await senderRequestsCollection.doc(receiverId).get();

    if (receiverDocSnapshot.exists) {
      Map<String, dynamic> data =
          receiverDocSnapshot.data() as Map<String, dynamic>;
      String status = data['status'];
      return status == 'accepted';
    } else {
      return false;
    }
  }

  Future<void> acceptConnection(String senderId, String receiverId) async {
    // Update sender's status to 'accepted'
    CollectionReference senderRequestsCollection =
        connectionCollection.doc(senderId).collection('requests');
    await senderRequestsCollection
        .doc(receiverId)
        .update({'status': 'accepted'});

    // Update receiver's status to 'accepted'
    CollectionReference receiverRequestsCollection =
        connectionCollection.doc(receiverId).collection('requests');
    await receiverRequestsCollection
        .doc(senderId)
        .update({'status': 'accepted'});
  }

  //get details by id
  Future<Map<String, dynamic>?> getDetailsById(String id) async {
    try {
      // Try fetching from the 'startups' collection
      DocumentSnapshot<Map<String, dynamic>> startupSnapshot =
          await FirebaseFirestore.instance.collection('startup').doc(id).get();

      if (startupSnapshot.exists) {
        Map<String, dynamic> startupData = startupSnapshot.data()!;
        return startupData;
      }

      DocumentSnapshot<Map<String, dynamic>> investorSnapshot =
          await FirebaseFirestore.instance.collection('investor').doc(id).get();

      if (investorSnapshot.exists) {
        Map<String, dynamic> investorData = investorSnapshot.data()!;
        return investorData;
      }
      // If document doesn't exist in either collection
      return null;
    } catch (e) {
      return null;
    }
  }

  Future toggleCommunityJoin(
      String groupId, String userName, String groupName) async {
    //doc references
    DocumentReference userReference = userCollection.doc(uid);
    DocumentReference groupReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups then remove and if not then give join option
    if (groups.contains("${groupId}_$groupName")) {
      await userReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$groupName"])
      });
    } else {
      await userReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$groupName"])
      });
    }
  }

  // Future toggleConnection(
  //     String ownId, String otherPersonId, String status) async {
  //   // Doc references
  //   DocumentReference userReference = connectionCollection.doc(ownId);
  //   DocumentReference otherPersonReference =
  //       connectionCollection.doc(otherPersonId);

  //   // Fetch existing data
  //   DocumentSnapshot userSnapshot = await userReference.get();
  //   DocumentSnapshot otherPersonSnapshot = await otherPersonReference.get();

  //   // Update user's connections
  //   List<dynamic> userConnections = List.from(userSnapshot['connection'] ?? []);
  //   if (status == 'connected') {
  //     // Add connection if not already connected
  //     if (!userConnections.contains(otherPersonId)) {
  //       userConnections.add(otherPersonId);
  //     }
  //   } else if (status == 'disconnect') {
  //     // Remove connection if connected
  //     userConnections.remove(otherPersonId);
  //   } else if (status == 'pending') {
  //     // Add connection to pending if not already pending
  //     if (!userConnections.contains(otherPersonId)) {
  //       userConnections.add({'id': otherPersonId, 'status': 'pending'});
  //     }
  //   } else if (status == 'accepted') {
  //     // Update status to 'connected' if pending
  //     for (var connection in userConnections) {
  //       if (connection['id'] == otherPersonId &&
  //           connection['status'] == 'pending') {
  //         connection['status'] = 'connected';
  //       }
  //     }
  //   }
  // }

  sendMessage(String groupId, Map<String, dynamic> chatMessage) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessage);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessage['message'],
      "recentMessageSender": chatMessage['sender'],
      "recentMessageTime": chatMessage['time'].toString(),
    });
  }
}
