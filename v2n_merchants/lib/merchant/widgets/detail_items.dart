import 'package:flutter/material.dart';

class TransactionDetailItems extends StatelessWidget {
  const TransactionDetailItems({
    super.key,
    required this.name,
    required this.title,
  });

  final String title;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "$title: ${name}",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }
}
