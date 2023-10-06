import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;

  OnboardingSlide({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.06, // Adjust font size
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.02), // Adjust spacing
        Text(
          description,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.045, // Adjust font size
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
