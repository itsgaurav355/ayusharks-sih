import 'package:ayusharks/pages/profile/investor_profile.dart';
import 'package:ayusharks/pages/profile/profile.dart';
import 'package:ayusharks/pages/profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helper/helper_function.dart';
import '../../model/investor.dart';
import '../../model/startup_user.dart';
import '../../services/investor/investor_services.dart';
import '../../services/startup/startup_services.dart';

class ProfileManager extends StatefulWidget {
  const ProfileManager({super.key});

  @override
  State<ProfileManager> createState() => _ProfileManagerState();
}

class _ProfileManagerState extends State<ProfileManager> {
  String userName = "";
  String userEmail = "";
  String userType = "";
  String id = FirebaseAuth.instance.currentUser!.uid;
  StartUp? startUp;
  final StartupServices _services = StartupServices();
  final InvestorServices _investorServices = InvestorServices();
  Investor? investor;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    gettingUserData();
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

    if (userType == "startup") {
      startUp = await _services.getStartupById(id);
    }
    if (userType == "investor") {
      investor = await _investorServices.getInvestorById(id);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : userType == "startup"
            ? ProfileScreen(
                startUp: startUp!,
              )
            : userType == "investor"
                ? InvestorProfile(
                    investor: investor!,
                  )
                : UserProfile(userName: userName, email: userEmail);
  }
}
