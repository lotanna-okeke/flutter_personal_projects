import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:onboarding/board.dart';
import 'package:onboarding/onboardScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardingScreen(),
      // home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController(initialPage: 0);
  final int _numPages = 3; // Number of slides

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (value) => _controller.animateToPage(
                      value,
                      duration: const Duration(milliseconds: 0),
                      curve: Curves.easeIn,
                    ),
                    controller: _controller,
                    itemCount: _numPages,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 150,
                              bottom: 20,
                              left: 20,
                              right: 20,
                            ),
                            width: 250,
                            child: Image.asset('assets\\images\\Logo.png'),
                          ),
                          const SizedBox(height: 100),
                          SmoothPageIndicator(
                            onDotClicked: (index) => _controller.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeIn,
                            ),
                            effect: WormEffect(
                              dotColor: Colors.black26,
                              spacing: 25,
                              activeDotColor: Colors.red,
                              dotWidth: 10,
                              dotHeight: 10,
                            ),
                            controller: _controller,
                            count: _numPages,
                          ),
                          const SizedBox(height: 50),
                          OnboardingSlide(
                            // You can customize the content of each slide here
                            // Pass different content for each slide
                            title: 'Slide $index',
                            description: 'Description for Slide $index',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
