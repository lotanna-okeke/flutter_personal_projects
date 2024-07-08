import 'package:flutter/material.dart';
import 'package:test/screens/auth.dart';
import 'package:test/widgets/tutorial_widget.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tutorial",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TutorialRowsColumn(
                  imageFile: 'assets/images/tutorial/date2.png',
                  head: 'Date',
                  bodyTop: 'Input the date a',
                  bodyBottom: 'certificate was given',
                ),
                Container(
                  margin: const EdgeInsets.only(left: 80, top: 40),
                  alignment: Alignment.bottomRight,
                  width: 80,
                  height: 150,
                  child: Image.asset('assets/images/tutorial/right.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 80, top: 40, left: 20),
                  alignment: Alignment.bottomRight,
                  width: 80,
                  height: 150,
                  child: Image.asset('assets/images/tutorial/left.png'),
                ),
                const TutorialRowsColumn(
                  imageFile: 'assets/images/tutorial/document2.png',
                  head: 'Document',
                  bodyTop: 'Input the type',
                  bodyBottom: 'of certificate gotten',
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 30, left: 60, bottom: 80),
              child: const TutorialRowsColumn(
                imageFile: 'assets/images/tutorial/relax2.png',
                head: 'Relax',
                bodyTop: 'Sit back while we',
                bodyBottom: 'track its expiry for you',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthScreen(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
