import 'package:flutter/material.dart';

class IncubatorInfo extends StatefulWidget {
  static const String routeName = '/incubator';
  final String selectedValue;

  const IncubatorInfo({Key? key, required this.selectedValue})
      : super(key: key);

  @override
  State<IncubatorInfo> createState() => _IncubatorInfoState();
}

class _IncubatorInfoState extends State<IncubatorInfo> {
  int currentStep = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incubator Registration'),
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
        title: Text('About Incubator'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Upload Profile Picture'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Incubator Name'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Date of Establishment'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Number of Startups Supported'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Program Duration'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Industry'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Interests'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Select Stages of Startup'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Brief Description'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'No. of Startups Graduated'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Government Funded (Yes/No)'),
            ),
          ],
        ),
      ),
      Step(
        title: Text('Contact Info'),
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
                  InputDecoration(labelText: 'Incubator Centre Location Map'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Incubator Centre Location Address'),
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
      Step(
        title: Text('Success Stories'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Startup Logo'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Startup Name'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Website/Mobile App Link'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter the Incubator IN'),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Startup India Hub Profile Link'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Brief Tagline'),
            ),
          ],
        ),
      ),
    ];
  }

  void submitForm() {}
}
