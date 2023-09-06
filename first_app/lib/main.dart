import 'package:flutter/material.dart';
import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer.night(),
        // body: GradientContainer([Colors.black, Colors.white]),
      ),
    ),
  );
}
