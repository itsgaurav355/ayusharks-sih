import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
          fontFamily: 'Nunito',
          fontSize: 15,
        ),
      ),
    );
  }
}
