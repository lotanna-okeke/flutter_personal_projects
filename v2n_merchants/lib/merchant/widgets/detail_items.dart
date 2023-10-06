import 'package:flutter/material.dart';

class TransactionDetailItems extends StatelessWidget {
  const TransactionDetailItems({
    super.key,
    required this.name,
    required this.title,
    required this.fontSize,
  });

  final String title;
  final String? name;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "$title: ${name}",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      ),
    );
  }
}
