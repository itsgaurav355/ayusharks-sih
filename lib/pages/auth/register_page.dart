import 'package:ayusharks/constants/bottom_bar.dart';
import 'package:ayusharks/pages/auth/login_page.dart';
import 'package:ayusharks/services/auth/auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../constants/global_variable.dart';

import '../../widget/widget.dart';
import '../registration/accelerator_info.dart';
import '../registration/investor_info.dart';
import '../registration/start_up_info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  String userType = "";
  List<String> type = [
    "Public User",
    "Start Up",
    "Investor",
    "Accelerator",
    "Mentor",
  ];
  String selectedItem = "Public User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Ayusharks",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            "Grow Your Business with the Ayush Community",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white)),
                        Image.asset("assets/register.png"),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              labelText: "Full Name",
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 55, 8, 242),
                              )),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              labelStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 55, 8, 242),
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 55, 8, 242),
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Which type of account do you want?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
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
                              if (item.toString() == "Start Up") {
                                userType = "startup";
                              } else if (item.toString() == "Investor") {
                                userType = "investor";
                              } else if (item.toString() == "Accelerator") {
                                userType = "accelerator";
                              } else if (item.toString() == "Mentor") {
                                userType = "mentor";
                              } else {
                                userType = "user";
                              }
                            }),
                            items: type.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                              "Register",
                              style: TextStyle(
                                  color: Constants.primaryColor, fontSize: 16),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login now",
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signUpUserWithCredentials(fullName, email, password, userType)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          // await HelperFunctions.saveUserLoggedInStatus(true, false);

          // ignore: use_build_context_synchronously
          _navigateToNextPage();
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _navigateToNextPage() {
    if (selectedItem.isNotEmpty) {
      switch (selectedItem) {
        case "Start Up":
          nextScreenReplace(
              context, const StartUpInfo(selectedValue: "startup"));
          break;
        case "Investor":
          nextScreenReplace(
              context, const InvestorInfo(selectedValue: "investor"));
          break;
        case "Accelerator":
          nextScreenReplace(
              context, const AcceleratorInfo(selectedValue: "accelerator"));
          break;
        case "Mentor":
          nextScreenReplace(
              context, const StartUpInfo(selectedValue: "mentor"));
          break;
        case "Public User":
          nextScreenReplace(context, const MyBottomBar());
          break;
      }
    }
  }
}
