import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/model/startup_user.dart';
import 'package:ayusharks/pages/chat/community/community_home.dart';
import 'package:ayusharks/pages/chat/individual/chat_list.dart';
import 'package:ayusharks/pages/connection_request.dart';
import 'package:ayusharks/pages/explore_page.dart';
import 'package:ayusharks/pages/funding_option/funding_page_controller.dart';
import 'package:ayusharks/pages/profile/new_profile.dart';
import 'package:ayusharks/pages/profile/profile_controller.dart';
// import 'package:ayusharks/pages/funding_option/start_up_funding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../helper/helper_function.dart';
import '../services/database_services.dart';

class MyBottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<MyBottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  StartUp? strartUp;
  String userName = "";
  String userType = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //string manipulation
  String getGroupId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getGroupName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    setState(() {
      _isLoading = true;
    });
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserTypeFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    //getting the list of snapshot in our stream
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  List<Widget> pages = [
    const FundingPageController(),
    // const StartUpFunding(),
    const ExploreScreen(),
    const CommunityHome(),
    const ConnectionRequestWidget(),
    // const MyProfile()
    const ProfileManager()
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.white,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //Home navigation
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: "",
          ),
          //explore page
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.search,
              ),
            ),
            label: "",
          ),

          //Account Navigation
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.message_outlined,
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 3
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_add_alt,
              ),
            ),
            label: "",
          ),

          //Profile Navigation
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 4
                        ? Colors.blue
                        : Theme.of(context).primaryColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.white,
                ),
                child: Icon(
                  Icons.person_2_outlined,
                ),
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
