import 'dart:typed_data';
import 'package:ayusharks/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ayusharks/services/investor/investor_services.dart';
import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/widget/widget.dart';
import '../../constants/utils.dart';

class InvestorInfo extends StatefulWidget {
  final String selectedValue;
  const InvestorInfo({super.key, required this.selectedValue});

  @override
  State<InvestorInfo> createState() => _InvestorInfoState();
}

class _InvestorInfoState extends State<InvestorInfo> {
  String investorName = "";
  String brief = "";
  int budget = 0;
  String pancard = "";
  String mobileno = "";
  String linkedIn = "";
  String? startUpName;
  int? investedAmount;
  int? profitGenerated;
  String? startupLink;
  bool haveSuccss = false;
  String? role = "";

  final _investorinfokey = GlobalKey<FormState>();
  final InvestorServices _investorRegistration = InvestorServices();

  Uint8List? _image;
  Uint8List? startUpLogo;

  List<String> selectState = ["Maharashtra", "Pune", "delhi", "Up"];
  String selectedState = "Maharashtra";

  List<String> selectCity = ["Mumbai", "Thane", "Banaras", "Manali"];
  String selectedCity = "Mumbai";

  List<String> selectIndustry = [
    "Medical",
    "Technical",
    "Biological",
    "Ayurvedic"
  ];
  String selectedIndustry = "Medical";

  List<String> selectSector = [
    "Ayurveda",
    "Yoga",
    "Unani",
    "Sidha",
    "Homeopathy"
  ];
  String selectedSector = "Ayurveda";

  List<String> selectStage = [
    "Ideation",
    "Validation",
    "Early Traction",
    "Scaling"
  ];
  String selectedStage = "Ideation";

  List<String> investorType = [
    "Angel group",
    "Private Company",
    "Venture Capital",
    "Private Equity"
  ];

  String selectedInvestorType = "Angel group";

  List<String> intrest = [
    "offline",
    "online",
    "others",
  ];
  String selectedIntrest = "";

  void selectImages() async {
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      _image = res;
    });
  }

  void startUpImage() async {
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      startUpLogo = res;
    });
  }

  void createInvestor() async {
    try {
      if (_investorinfokey.currentState!.validate() && _image != null) {
        if (haveSuccss) {
          await _investorRegistration.createInvestorWithSuccess(
            context: context,
            id: FirebaseAuth.instance.currentUser!.uid,
            images: _image!,
            stage: selectedStage,
            industry: selectedIndustry,
            state: selectedState,
            city: selectedCity,
            linkedIn: linkedIn,
            investorname: investorName,
            pancard: pancard,
            budget: budget.toDouble(),
            brief: brief,
            mobileno: mobileno,
            type: widget.selectedValue,
            startUpName: startUpName!,
            startUpImage: startUpLogo!,
            investedAmount: investedAmount!,
            profit: profitGenerated!,
            startupLink: startupLink!,
            investorType: selectedIndustry,
            sector: selectedSector,
            intrest: selectedIntrest,
            role: role!,
          );
          // ignore: use_build_context_synchronously
          showSnackBar(context,
              "Investor Created Successfully , login to your account now ");
          // await HelperFunctions.saveUserLoggedInStatus(true, true);
          navigateToHome();
        } else {
          await _investorRegistration.createInvestor(
            id: FirebaseAuth.instance.currentUser!.uid,
            context: context,
            images: _image!,
            stage: selectedStage,
            industry: selectedIndustry,
            state: selectedState,
            city: selectedCity,
            linkedIn: linkedIn,
            investorname: investorName,
            pancard: pancard,
            budget: budget.toDouble(),
            brief: brief,
            mobileno: mobileno,
            type: widget.selectedValue,
            investorType: selectedInvestorType,
            sector: selectedSector,
            intrest: selectedIntrest,
            role: role!,
          );
          // ignore: use_build_context_synchronously
          showSnackBar(context,
              "Investor Created Successfully , login to your account now ");
          // await HelperFunctions.saveUserLoggedInStatus(true, true);
          navigateToHome();
        }
      }
    } catch (e) {
      showSnackBar(context, "All fields are required ${e.hashCode}");
    }
  }

  void navigateToHome() {
    nextScreenReplace(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(" AyuSharks "),
      ),
      body: Material(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Form(
                  key: _investorinfokey,
                  child: Column(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                            ),
                      CircleAvatar(
                        child: IconButton(
                          onPressed: selectImages,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Investor Name",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            investorName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Investor name cannot be empty";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Role",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            investorName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Role cannot be empty";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedStage,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedStage = item!;
                          }),
                          items: selectStage.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Brief",
                          prefixIcon: const Icon(
                            Icons.description,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            brief = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please add brief details";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedSector,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedSector = item!;
                          }),
                          items: selectSector.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedInvestorType,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedInvestorType = item!;
                          }),
                          items: investorType.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.9,
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5),
                      //     border: Border.all(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     dropdownColor: Constants.primaryColor,
                      //     isExpanded: true,
                      //     value: selectedIntrest,
                      //     icon: const Icon(
                      //       Icons.arrow_drop_down,
                      //       color: Colors.white,
                      //     ),
                      //     iconSize: 24,
                      //     elevation: 16,
                      //     style: const TextStyle(
                      //         color: Colors.white, fontSize: 16),
                      //     underline: Container(
                      //       height: 2,
                      //       color: Theme.of(context).primaryColor,
                      //     ),
                      //     onChanged: (item) => setState(() {
                      //       selectedIntrest = item!;
                      //     }),
                      //     items: intrest.map((item) {
                      //       return DropdownMenuItem<String>(
                      //         value: item,
                      //         child: Text(item,
                      //             style: const TextStyle(
                      //                 fontSize: 16, color: Colors.white)),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Budget",
                          prefixIcon: const Icon(
                            Icons.attach_money,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            budget = int.parse(val);
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please enter budget correctly";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedState,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedState = item!;
                          }),
                          items: selectState.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedIndustry,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedIndustry = item!;
                          }),
                          items: selectIndustry.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Mobile No.",
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            mobileno = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length == 10) {
                            return null;
                          } else {
                            return "Mobile Number should be 10 digits only";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Pancard No.",
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            pancard = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length == 16) {
                            return null;
                          } else {
                            return "Pan Card Number should be 16 digits only";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Constants.primaryColor,
                          isExpanded: true,
                          value: selectedCity,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (item) => setState(() {
                            selectedCity = item!;
                          }),
                          items: selectCity.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Linked In URL",
                          prefixIcon: const Icon(
                            Icons.link,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            linkedIn = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "URL cannot be empty";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      startUpLogo != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(startUpLogo!),
                            )
                          : ListTile(
                              title: const Text(
                                'Success Stories',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Checkbox(
                                value: haveSuccss,
                                onChanged: (bool? value) {
                                  setState(() {
                                    haveSuccss = value ?? false;
                                  });
                                },
                              ),
                            ),
                      if (haveSuccss)
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                            ),
                            CircleAvatar(
                              child: IconButton(
                                onPressed: selectImages,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: textInputDecoration.copyWith(
                                labelText: "StartUp Name",
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 55, 8, 242),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  startUpName = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "StartUp name cannot be empty";
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                labelText: "Profit Generated",
                                prefixIcon: const Icon(
                                  Icons.monetization_on_outlined,
                                  color: Color.fromARGB(255, 55, 8, 242),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  profitGenerated = int.parse(val);
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty && profitGenerated! > 0) {
                                  return null;
                                } else {
                                  return "Profit can't be negative";
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Invested Amount",
                                  prefixIcon: const Icon(
                                    Icons.monetization_on_outlined,
                                    color: Color.fromARGB(255, 55, 8, 242),
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  investedAmount = int.parse(val);
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty && investedAmount! > 0) {
                                  return null;
                                } else {
                                  return "Invement can't be negative";
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Web/App link",
                                  prefixIcon: const Icon(
                                    Icons.link,
                                    color: Color.fromARGB(255, 55, 8, 242),
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  startupLink = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty && startupLink != null) {
                                  return null;
                                } else {
                                  return "StartUp website URL is needed";
                                }
                              },
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Register Investor",
                      style: TextStyle(
                          color: Constants.primaryColor, fontSize: 16),
                    ),
                    onPressed: () {
                      createInvestor();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
