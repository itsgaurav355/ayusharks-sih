import 'dart:typed_data';
import 'package:ayusharks/components/mybutton.dart';
import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/pages/auth/login_page.dart';
import 'package:ayusharks/services/startup/startup_services.dart';
import 'package:ayusharks/widget/widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/utils.dart';

class StartUpInfo extends StatefulWidget {
  final String selectedValue;
  const StartUpInfo({super.key, required this.selectedValue});

  @override
  State<StartUpInfo> createState() => _StartUpInfoState();
}

class _StartUpInfoState extends State<StartUpInfo> {
  String companyname = "";
  int investment = 0;
  double revenue = 0.0;
  double equity = 0.0;
  String cin = "";
  String description = "";
  double pm = 0.0;
  Uint8List? _image;
  String selectedStage = 'Ideation';
  String msmeNumber = '';
  String selectedsector = 'Ayurveda';
  String selectedServicesType = 'offline';
  String selectedIndustry = "Medical";

  final _startupinfokey = GlobalKey<FormState>();
  final StartupServices _startupregister = StartupServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<String> selectStage = [
    "Ideation",
    "Validation",
    "Early Traction",
    "Scaling"
  ];
  List<String> selectSector = [
    "Ayurveda",
    "Yoga",
    "Unani",
    "Sidha",
    "Homeopathy"
  ];
  List<String> industry = [
    "Medical",
    "Technical",
    "Biotech",
  ];
  List<String> serviceType = [
    "offline",
    "online",
    "others",
  ];

  void selectImages() async {
    // var res = await pickImages();
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      _image = res;
    });
  }

  void createStartup() async {
    try {
      if ((_startupinfokey.currentState!.validate() && _image != null)) {
        await _startupregister.createStartup(
          context: context,
          image: _image!,
          id: _firebaseAuth.currentUser!.uid,
          companyname: companyname,
          investement: investment,
          profitmargin: pm,
          equity: equity,
          cin: cin,
          revenue: revenue,
          description: description,
          stage: selectedStage,
          msmeNumber: msmeNumber,
          industry: selectedIndustry,
          sector: selectedsector,
          servicesType: selectedServicesType,
        );

        // ignore: use_build_context_synchronously
        showSnackBar(context,
            "Start Up account created Successfully , Login to your account now !");
        navigateToHome();
      }
    } catch (e) {
      showSnackBar(context, "All fields are need to be field ${e.toString()}");
    }
  }

  void navigateToHome() {
    nextScreenReplace(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        title: const Text(
          " AyuSharks ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Material(
        color: Constants.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _startupinfokey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your details below for ${widget.selectedValue}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  //company name
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(
                      labelText: "Company Name",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 55, 8, 242),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        companyname = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Company name cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  //stage
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  //profit margin
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Profit Margin Amount",
                        prefixIcon: const Icon(
                          Icons.monetization_on_outlined,
                          color: Color.fromARGB(255, 55, 8, 242),
                        )),
                    onChanged: (val) {
                      setState(() {
                        pm = double.parse(val);
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Profit Margin is in incorrect";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  //select industry
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (item) => setState(() {
                        selectedIndustry = item!;
                      }),
                      items: industry.map((item) {
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
                  //equity
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Equity",
                        prefixIcon: const Icon(
                          Icons.percent,
                          color: Color.fromARGB(255, 55, 8, 242),
                        )),
                    onChanged: (val) {
                      setState(() {
                        equity = double.parse(val);
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty && equity < 100) {
                        return null;
                      } else {
                        return "Equity is in incorrect";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  //cin
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        labelText: "CIN",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 55, 8, 242),
                        )),
                    onChanged: (val) {
                      setState(() {
                        cin = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty && val.length == 16) {
                        return null;
                      } else {
                        return "CIN should be 16 digits only";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  // service type
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
                      value: selectedServicesType,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (item) => setState(() {
                        selectedServicesType = item!;
                      }),
                      items: serviceType.map((item) {
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
                  //msmse
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        labelText: "MSME Registered number",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 55, 8, 242),
                        )),
                    onChanged: (val) {
                      setState(() {
                        msmeNumber = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "MSME is incorrect";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  //sector
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
                      value: selectedsector,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (item) => setState(() {
                        selectedsector = item!;
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
                  //revenue
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Reveneu Amount",
                        prefixIcon: const Icon(
                          Icons.monetization_on_outlined,
                          color: Color.fromARGB(255, 55, 8, 242),
                        )),
                    onChanged: (val) {
                      setState(() {
                        revenue = double.parse(val);
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Revenue is in incorrect";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  //description
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(
                      labelText: "Description ",
                      prefixIcon: const Icon(
                        Icons.description,
                        color: Color.fromARGB(255, 55, 8, 242),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        description = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Description should be at least of 50 characters";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
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
                        "Register Startup",
                        style: TextStyle(
                            color: Constants.primaryColor, fontSize: 16),
                      ),
                      onPressed: () {
                        createStartup();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
