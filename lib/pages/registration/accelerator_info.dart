import 'dart:typed_data';
import 'package:ayusharks/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayusharks/services/accelerator/accelerator_services.dart';
import 'package:ayusharks/constants/global_variable.dart';
import 'package:ayusharks/widget/widget.dart';

class AcceleratorInfo extends StatefulWidget {
  final String selectedValue;
  const AcceleratorInfo({super.key, required this.selectedValue});

  @override
  State<AcceleratorInfo> createState() => _AcceleratorInfoState();
}

class _AcceleratorInfoState extends State<AcceleratorInfo> {
  String acceleratorName = "";
  String stage = "";
  String brief = "";
  int budget = 0;
  String industry = "";
  String pancard = "";
  String mobileno = "";
  String state = "";
  String city = "";
  String linkedIn = "";
  String? startUpName;
  int? investedAmount;
  int? profitGenerated;
  String? startupLink;
  String dateOfEstablishment = "";
  String sector = "";
  String interests = "";
  String role = "";
  String acceleratorCentreLocation = "";
  bool haveSuccess = false;
  final _acceleratorinfokey = GlobalKey<FormState>();
  final AcceleratorServices _acceleratorRegistration = AcceleratorServices();

  Uint8List? images;
  Uint8List? startUpLogo;

  List<String> sectorList = ["Sector1", "Sector2", "Sector3", "Sector4"];
  String selectedSector = "Sector1";

  List<String> selectState = ["Maharashtra", "Pune", "Delhi", "UP"];
  String selectedState = "Maharashtra";

  List<String> selectCity = ["Mumbai", "Thane", "Banaras", "Manali"];
  String selectedCity = "Mumbai";

  List<String> selectStage = [
    "Ideation",
    "Validation",
    "Early Traction",
    "Scaling"
  ];
  String selectedItem = "Ideation";

  void selectImages() async {
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      images = res;
    });
  }

  void selectStartUpLogo() async {
    var res = await pickImage(ImageSource.gallery);
    setState(() {
      startUpLogo = res;
    });
  }

  void createAccelerator() async {
    try {
      if (_acceleratorinfokey.currentState!.validate() && images != null) {
        if (haveSuccess) {
          await _acceleratorRegistration.createAcceleratorWithSuccess(
            context: context,
            id: FirebaseAuth.instance.currentUser!.uid,
            images: images!,
            stage: selectedItem,
            industry: selectedSector,
            state: selectedState,
            city: selectedCity,
            linkedIn: linkedIn,
            investorname: acceleratorName,
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
          );
          // ignore: use_build_context_synchronously
          showSnackBar(context,
              "Investor Created Successfully , login to your account now ");
          // await HelperFunctions.saveUserLoggedInStatus(true, true);
          navigateToHome();
        } else {
          await _acceleratorRegistration.createAccelerator(
            id: FirebaseAuth.instance.currentUser!.uid,
            context: context,
            images: images!,
            stage: selectedItem,
            industry: industry,
            state: selectedState,
            city: selectedCity,
            linkedIn: linkedIn,
            investorname: acceleratorName,
            pancard: pancard,
            budget: budget.toDouble(),
            brief: brief,
            mobileno: mobileno,
            type: widget.selectedValue,
          );
          // ignore: use_build_context_synchronously
          showSnackBar(context,
              "Accelerator Created Successfully , login to your account now ");
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
                  key: _acceleratorinfokey,
                  child: Column(
                    children: [
                      images != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(images!),
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
                        keyboardType: TextInputType.datetime,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Date of Establishment",
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            dateOfEstablishment = val;
                          });
                        },
                        validator: (val) {
                          return null;
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
                          value: sector,
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
                            sector = item!;
                          }),
                          items: sectorList.map((item) {
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
                          labelText: "Interests",
                          prefixIcon: const Icon(
                            Icons.favorite,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            interests = val;
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Role",
                          prefixIcon: const Icon(
                            Icons.work,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            role = val;
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Accelerator Centre Location",
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            acceleratorCentreLocation = val;
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Accelerator Name",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 55, 8, 242),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            acceleratorName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Accelerator name cannot be empty";
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
                          value: selectedItem,
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
                            selectedItem = item!;
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
                          labelText: "Add Brief",
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
                          if (!(val!.length == 10)) {
                            return null;
                          } else {
                            return "Mobile Number should be 10 digits only";
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
                          labelText: "Website",
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
                      startUpLogo!.isNotEmpty
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(startUpLogo!),
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
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    createAccelerator();
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
