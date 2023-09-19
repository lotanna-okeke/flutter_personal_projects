import 'package:flutter/material.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({
    super.key,
    required this.icon,
    required this.title,
    required this.balance,
  });

  final IconData icon;
  final String title;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              const SizedBox(width: 20),
              Text(
                "$title: \t\t ₦$balance",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              // const SizedBox(width: 20),
              // Text(
              //   "$title",
              //   style: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 30,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
