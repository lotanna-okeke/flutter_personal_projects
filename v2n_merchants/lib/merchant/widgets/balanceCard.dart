import 'package:flutter/material.dart';
import 'package:v2n_merchants/data.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({
    super.key,
    required this.icon,
    required this.title,
    required this.balance,
  });

  final IconData icon;
  final String title;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        // color: Colors.white,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
              Expanded(
                child: Text(
                  "$title: ₦${formatNumberWithCommas(balance)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
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
