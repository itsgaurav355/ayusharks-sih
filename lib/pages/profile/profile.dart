import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/model/startup_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  StartUp startUp;
  ProfileScreen({super.key, required this.startUp});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String userEmail = "";
  String userType = "";
  String id = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    gettingUserData();
    setState(() {
      isLoading = false;
    });
  }

  gettingUserData() async {
    setState(() {
      isLoading = true;
    });
    await HelperFunctions.getUserTypeFromSF().then((val) {
      setState(() {
        userType = val!;
      });
    });
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserTypeFromSF().then((val) {
      setState(() {
        userType = val!;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Constants.primaryColor,
              title: Text(
                userName,
                style: const TextStyle(
                  fontFamily: "Nisebuschgardens",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Constants.primaryColor,
                        Color.fromRGBO(0, 30, 59, 1),
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 73),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.47,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: innerHeight * 0.72,
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 60,
                                            ),
                                            Text(
                                              widget.startUp.companyName,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontFamily: 'Nunito',
                                                fontSize: 37,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                widget.startUp.description,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Investment',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.startUp.investement
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            172, 0, 0, 1),
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 25,
                                                    vertical: 8,
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 3,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Revenue",
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.startUp.revenue
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            172, 0, 0, 1),
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 120,
                                      right: 15,
                                      child: Icon(
                                        Icons.add_box,
                                        color: Colors.grey[700],
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Image.network(
                                          widget.startUp.images,
                                          width: innerWidth * 0.45,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          SizedBox(
                            height: height * 0.33,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: innerHeight * 0.72,
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Profit Margin",
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget
                                                          .startUp.profitmargin
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            172, 0, 0, 1),
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 25,
                                                    vertical: 1,
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 3,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Equity',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.startUp.equity
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            172, 0, 0, 1),
                                                        fontFamily: 'Nunito',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            height: height * 0.5,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Invested in Companies',
                                    style: TextStyle(
                                      color: Color.fromRGBO(39, 105, 171, 1),
                                      fontSize: 27,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2.5,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
