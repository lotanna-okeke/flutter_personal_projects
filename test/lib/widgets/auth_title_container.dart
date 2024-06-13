import 'package:flutter/material.dart';

class AuthTitleContainer extends StatelessWidget {
  const AuthTitleContainer({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, top: 20),
      alignment: Alignment.bottomLeft,
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 15,
          color: Color.fromARGB(199, 0, 0, 0),
        ),
      ),
    );
  }
}
