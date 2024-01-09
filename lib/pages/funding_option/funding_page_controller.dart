import 'package:ayusharks/helper/helper_function.dart';
import 'package:ayusharks/pages/funding_option/investor_funding.dart';
import 'package:ayusharks/pages/funding_option/start_up_funding.dart';
import 'package:flutter/material.dart';

class FundingPageController extends StatefulWidget {
  const FundingPageController({super.key});

  @override
  State<FundingPageController> createState() => _FundingPageControllerState();
}

class _FundingPageControllerState extends State<FundingPageController> {
  String userType = "";
  final bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserType();
  }

  getUserType() {
    var res = HelperFunctions.userTypeValue;
    setState(() {
      userType = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Funding Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Column(
                children: [
                  TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(
                        child: Text("StartUp",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                      Tab(
                        child: Text("Investor",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                      )
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        StartUpFunding(),
                        InvestorFunding(),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
