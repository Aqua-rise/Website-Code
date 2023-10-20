import 'package:flutter/material.dart';

class SetBoxes extends StatelessWidget {
  const SetBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 199,
        height: 199,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
        ),
        child: const Center(
          child: Text(
            'Flashcards',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
