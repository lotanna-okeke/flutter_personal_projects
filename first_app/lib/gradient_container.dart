import 'package:first_app/dice_roller.dart';
import 'package:first_app/styled_text.dart';
import 'package:flutter/material.dart';

var startAlignment = Alignment.bottomLeft;
var endAlignment = Alignment.topRight;

class GradientContainer extends StatelessWidget {
  // const GradientContainer({key}) : super(key:key); //The first key in super is for the statelesswidget key, while the second one is the key of the new Widget
  // Another way of doing it is
  const GradientContainer(this.colors, {super.key});

  //This ia called an alternative constructor function
  const GradientContainer.ocean({super.key})
      : colors = const [
          Color.fromARGB(255, 0, 5, 61),
          Color.fromARGB(255, 42, 66, 152),
          Color.fromARGB(255, 119, 186, 238)
        ];

  const GradientContainer.night({super.key})
      : colors = const [
          Color.fromARGB(255, 82, 71, 144),
          Color.fromARGB(255, 49, 40, 108),
          Color.fromARGB(255, 47, 38, 107),
          Color.fromARGB(255, 31, 23, 79),
          Color.fromARGB(255, 22, 14, 64),
        ];
  final List<Color> colors;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAlignment,
          //or
          //begin: Alignment(-1, -1),
          end: endAlignment,
          //or
          // end: Alignment(1, 1),
        ),
      ),
      child: const Center(
        child: DiceRoller(),
        // child: StyledText('Hello Worlds', Colors.white, 30),
      ),
    );
  }
}
