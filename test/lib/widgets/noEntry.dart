import 'package:flutter/material.dart';

class NoEntry extends StatelessWidget {
  const NoEntry({super.key, required this.icons, required this.text});

  final IconData icons;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons as IconData? ?? Icons.error,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
