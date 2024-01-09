import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/pages/profile/profile_controller.dart';
import 'package:ayusharks/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  String userId = FirebaseAuth.instance.currentUser!.uid;
  User? user;
  bool isConnected = false;
  String status = 'not_connected';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getCurrentUser() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search ... ",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : startupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseServices()
          .searchByStartUpName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  startupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return startupTile(
                searchSnapshot!.docs[index]['image'],
                searchSnapshot!.docs[index]['id'],
                searchSnapshot!.docs[index]['companyname'],
                searchSnapshot!.docs[index]['profitmargin'],
              );
            },
          )
        : const Text("");
  }

  Widget startupTile(
      String image, String startUpId, String companyName, double profit) {
    return FutureBuilder<String>(
      future: DatabaseServices(uid: userId).getConnectionStatus(startUpId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          String status = snapshot.data ?? 'not_connected';
          return SingleChildScrollView(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Image.network(image),
              ),
              title: Text(
                companyName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text("Profit: $profit "),
              trailing: SizedBox(
                  height: 40,
                  width: 120,
                  child: buildConnectionButton(startUpId, status)),
            ),
          );
        }
      },
    );
  }

  Widget buildConnectionButton(String startUpId, String status) {
    if (user != null && startUpId != userId) {
      if (status == 'accepted') {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            "Connected",
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return FutureBuilder<bool>(
          future: DatabaseServices(uid: userId)
              .doesConnectionRequestExist(startUpId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else {
              bool connectionRequestExists = snapshot.data ?? false;
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                    color: status == 'accepted'
                        ? Colors.black
                        : status == 'pending'
                            ? Colors.red[200]
                            : Theme.of(context).primaryColor,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    status == 'accepted'
                        ? "Connected"
                        : status == 'pending'
                            ? "Connection Pending"
                            : "Connect",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () async {
                  if (user != null && startUpId != user!.uid) {
                    if (connectionRequestExists) {
                      if (status == 'pending') {
                        await DatabaseServices(uid: userId)
                            .removeConnectionRequest(startUpId);
                        await DatabaseServices(uid: userId)
                            .removeConnection(startUpId);
                        await DatabaseServices(uid: userId)
                            .updateConnectionStatus(startUpId, 'not_connected');
                      } else {
                        await DatabaseServices(uid: userId)
                            .removeConnection(startUpId);
                        await DatabaseServices(uid: userId)
                            .updateConnectionStatus(startUpId, 'not_connected');
                      }
                    } else {
                      await DatabaseServices(uid: userId)
                          .sendConnectionRequest(user!.uid, startUpId);
                      await DatabaseServices(uid: userId)
                          .updateConnectionStatus(startUpId, 'pending');
                    }

                    // Update the status in the widget's state
                    setState(() {
                      status =
                          status == 'pending' ? 'not_connected' : 'pending';
                    });
                  }
                },
              );
            }
          },
        );
      }
    } else {
      return InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileManager(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            "View",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // buildConnectionButton(String startUpId, String status) {}
  // Widget buildConnectionButton(String startUpId, String status) {
  //   if (user != null && startUpId != userId) {
  //     if (status == 'accepted') {
  //       return Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Colors.black,
  //           border: Border.all(color: Colors.white, width: 1),
  //         ),
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         child: const Text(
  //           "Connected",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       );
  //     } else {
  //       return FutureBuilder<bool>(
  //         future: DatabaseServices(uid: userId)
  //             .doesConnectionRequestExist(startUpId),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(
  //               child: CircularProgressIndicator(
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             );
  //           } else {
  //             bool connectionRequestExists = snapshot.data ?? false;
  //             return InkWell(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: Colors.white, width: 1),
  //                   color: status == 'accepted'
  //                       ? Colors.black
  //                       : status == 'pending'
  //                           ? Colors.red[200]
  //                           : Theme.of(context).primaryColor,
  //                 ),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                 child: Text(
  //                   status == 'accepted'
  //                       ? "Connected"
  //                       : status == 'pending'
  //                           ? "Connection Pending"
  //                           : "Connect",
  //                   style: const TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //               onTap: () async {
  //                 if (user != null && startUpId != user!.uid) {
  //                   if (connectionRequestExists) {
  //                     if (status == 'pending') {
  //                       await DatabaseServices(uid: userId)
  //                           .removeConnectionRequest(startUpId);
  //                       await DatabaseServices(uid: userId)
  //                           .removeConnection(startUpId);
  //                       updateConnectionStatus(startUpId, 'not_connected');
  //                     } else {
  //                       await DatabaseServices(uid: userId)
  //                           .removeConnection(startUpId);
  //                       updateConnectionStatus(startUpId, 'not_connected');
  //                     }
  //                   } else {
  //                     await DatabaseServices(uid: userId)
  //                         .sendConnectionRequest(user!.uid, startUpId);
  //                     updateConnectionStatus(startUpId, 'pending');
  //                   }

  //                   // Add this line to rebuild the widget with the updated status
  //                   setState(() {
  //                     status = status;
  //                   });
  //                 }
  //               },
  //             );
  //           }
  //         },
  //       );
  //     }
  //   } else {
  //     return InkWell(
  //       onTap: () {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const ProfileManager(),
  //           ),
  //         );
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Theme.of(context).primaryColor,
  //           border: Border.all(color: Colors.white, width: 1),
  //         ),
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         child: const Text(
  //           "View",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void updateConnectionStatus(String startUpId, String newStatus) {
  //   setState(() {
  //     status = newStatus;
  //   });
  // }
}
