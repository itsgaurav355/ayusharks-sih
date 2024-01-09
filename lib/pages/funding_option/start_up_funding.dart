import 'package:ayusharks/helper/helper_function.dart';
import 'package:ayusharks/model/startup_user.dart';
import 'package:ayusharks/services/startup/startup_services.dart';
import 'package:flutter/material.dart';

class StartUpFunding extends StatefulWidget {
  const StartUpFunding({super.key});

  @override
  State<StartUpFunding> createState() => _StartUpFundingState();
}

class _StartUpFundingState extends State<StartUpFunding> {
  String userName = "";
  String userType = "";
  bool haveConnection = false;
  final StartupServices _startupServices = StartupServices();
  bool isLoading = false;

  // String? image;

  @override
  void initState() {
    super.initState();
    gettingInvestorData();
  }

  gettingInvestorData() async {
    setState(() {
      isLoading = true;
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
    return Scaffold(
      body: FutureBuilder<List<StartUp>>(
        future: _startupServices.getAllStartups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<StartUp> startups = snapshot.data ?? [];

            return ListView.builder(
              itemCount: startups.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Image.network(
                        startups[index].images,
                      )),
                  title: Text(
                    startups[index].companyName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Profit: ${startups[index].profitmargin} "),
                  trailing: InkWell(
                    onTap: () async {},
                    child: haveConnection
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: const Text(
                              "Connected",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: const Text(
                              "Connect",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
