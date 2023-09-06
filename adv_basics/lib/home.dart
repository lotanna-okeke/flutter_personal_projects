import 'package:adv_basics/questions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool? hov = true;

class Home extends StatelessWidget {
  const Home(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets\\images\\quiz-logo.png",
            width: 270,
            color: const Color.fromARGB(149, 253, 253, 253),
          ),

          ///another means of making it transparent
          // Opacity(
          //   opacity: 0.6,
          //   child: Image.asset(
          //     "assets\\images\\quiz-logo.png",
          //     width: 270,
          //   ),
          // ),

          const SizedBox(
            height: 60,
          ),
          Text(
            "Learn Flutter the fun way",
            style: GoogleFonts.russoOne(
              fontSize: 28,
              // fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          OutlinedButton(
            onPressed: () {
              startQuiz(); //call the switchscreen function in quizapp
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              // backgroundColor: Color.fromARGB(255, 34, 52, 118),
              // disabledBackgroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Start Quiz"),
                Padding(padding: EdgeInsets.only(left: 10)),
                Icon(Icons.arrow_right_alt_outlined),
              ],
            ),
            // icon: Icon(Icons.arrow_right_alt),
          ),

          ///Using .icon instead

          // OutlinedButton.icon(
          //   onPressed: () {},
          //   style: OutlinedButton.styleFrom(
          //     foregroundColor: Colors.white,
          //     // backgroundColor: Color.fromARGB(255, 34, 52, 118),
          //     // disabledBackgroundColor: Colors.red,
          //     textStyle: const TextStyle(fontSize: 20),
          //   ),
          //   label: const Text('Start Quiz'),
          //   icon: Icon(Icons.arrow_right_alt),
          // ),
        ],
      ),
    );
  }
}
