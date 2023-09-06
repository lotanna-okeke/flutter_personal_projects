import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(
      {super.key, required this.answerText, required this.onTap});

  final String answerText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 0),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 40,
            ),
            // foregroundColor: Color.fromARGB(255, 43, 184, 215),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            // side: BorderSide,
            textStyle: const TextStyle(
              fontSize: 18,
            ),
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          ),
          child: Text(
            answerText,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
