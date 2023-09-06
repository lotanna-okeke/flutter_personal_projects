import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StyledText extends StatelessWidget {
  StyledText(this.text, this.colored, this.size, {super.key});
  final String text;
  final Color colored;
  double size;

  @override
  Widget build(context) {
    return Text(
      text,
      style: TextStyle(
        color: colored,
        fontSize: size,
      ),
    );
  }
}
