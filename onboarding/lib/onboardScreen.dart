import 'package:flutter/material.dart';
import 'package:onboarding/board.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var logoColors = {
    1: const Color.fromARGB(255, 170, 0, 0),
    2: const Color.fromARGB(255, 189, 191, 193),
    3: const Color.fromARGB(255, 50, 50, 50)
  };
  var titles = [
    'Help Your Business?',
    'Multiple Businesses?',
    'Track Your Business Spending?'
  ];

  var subTitles = [
    'Become a merchant and watch your operations become easier ;)',
    'Register as many as 3 business as \'Merchants\' and enjoy our benefits on each merchant ',
    'View the balance and account history of your data, airtime and B2B operations with ease'
  ];

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
                              activeDotColor: logoColors[1]!,
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
                            title: titles[index],
                            description: subTitles[index],
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
          color: logoColors[1]!,
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Login',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
