import 'package:ayusharks/model/investor.dart';
import 'package:ayusharks/services/investor/investor_services.dart';
import 'package:flutter/material.dart';

class InvestorFunding extends StatefulWidget {
  const InvestorFunding({super.key});

  @override
  State<InvestorFunding> createState() => _InvestorFundingState();
}

class _InvestorFundingState extends State<InvestorFunding> {
  bool haveConnection = false;
  final InvestorServices _investorServices = InvestorServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Investor>>(
        future: _investorServices.getAllInvestors(),
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
            List<Investor> investors = snapshot.data ?? [];

            return ListView.builder(
              itemCount: investors.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Image.network(
                        investors[index].images,
                      )),
                  title: Text(
                    investors[index].investorname,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Budget: ${investors[index].budget} "),
                  trailing: InkWell(
                      onTap: () async {},
                      child: haveConnection
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
                            )),
                );
              },
            );
          }
        },
      ),
    );
  }
}
