import 'package:flutter/material.dart';

class TutorialRowsColumn extends StatelessWidget {
  const TutorialRowsColumn({
    super.key,
    required this.imageFile,
    required this.head,
    required this.bodyTop,
    required this.bodyBottom,
  });

  final String imageFile;
  final String head;
  final String bodyTop;
  final String bodyBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            width: 80,
            height: 80,
            child: Image.asset(
              imageFile,
              width: 50,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          head,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          bodyTop,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          bodyBottom,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
