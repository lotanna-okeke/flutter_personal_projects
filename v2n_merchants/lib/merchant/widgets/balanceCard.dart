import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({
    Key? key,
    required this.icon,
    required this.title,
    required this.balance,
    required this.fontSize,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final double balance;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth > 600 ? 40.0 : 30.0;

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
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: iconSize,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "$title: ₦${formatNumberWithCommas(balance)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
