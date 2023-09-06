import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      // textAlign: TextAlign.center,
      // style: TextStyle(color: Colors.red[400], fontSize: 16),
      // selectionColor: Colors.red,
    ),
    // backgroundColor: Color.fromARGB(149, 255, 4, 4),
  ));
}
