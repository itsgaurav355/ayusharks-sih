import 'package:flutter/material.dart';

class MyNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const MyNumberInput(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        fillColor: Colors.grey[350],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
