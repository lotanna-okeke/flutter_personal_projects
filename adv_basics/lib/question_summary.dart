import 'package:flutter/material.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary(
    this.summaryData, {
    super.key,
  });

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            children: summaryData.map(
          (data) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                Column(
                  textDirection: TextDirection.ltr,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: data['index_color'] as Color,
                        shape: const CircleBorder(eccentricity: 0),
                      ),
                      child: Text(
                        ((data['question_index'] as int) + 1).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 50),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (data['question']).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          // textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (data['user_answer']).toString(),
                          // textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 119, 186, 238),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          (data['correct_answer']).toString(),
                          // textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 184, 107, 251),
                            fontSize: 16,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10))
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ).toList()),
      ),
    );
  }
}
