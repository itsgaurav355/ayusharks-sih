import 'package:flutter/material.dart';

class GovernmentInfo extends StatefulWidget {
  static const String routeName = '/government';
  final String selectedValue;

  const GovernmentInfo({Key? key, required this.selectedValue})
      : super(key: key);

  @override
  State<GovernmentInfo> createState() => _GovernmentInfoState();
}

class _GovernmentInfoState extends State<GovernmentInfo> {
  int currentStep = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Agencies Registration'),
      ),
      body: Form(
        key: formKey,
        child: Stepper(
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < getSteps().length - 1) {
              setState(() {
                currentStep += 1;
              });
            } else {
              submitForm();
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep -= 1;
              });
            }
          },
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        title: Text('Basic Information'),
        content: Column(
          children: [
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Department/Ministry LOGO'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Name of Ministry/Department'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Ministry'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'About Your Department and Ministry'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Department'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Industry'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Interests'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Sector'),
            ),
          ],
        ),
      ),
      Step(
        title: Text('Contact Details'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Application Link'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Website/Social Media URL'),
            ),
          ],
        ),
      ),
      Step(
        title: Text('Point of Contact'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email ID'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Landline Number'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Website'),
            ),
          ],
        ),
      ),
    ];
  }

  void submitForm() {}
}
