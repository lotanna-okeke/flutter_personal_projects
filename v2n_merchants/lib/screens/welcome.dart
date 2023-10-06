import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/screens/login.dart';
import 'package:v2n_merchants/widgets/buildPage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

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

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController(initialPage: 0);
  final int _numPages = 3; // Number of slides

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.1), // Adjust padding
          child: Container(
            alignment: Alignment.center,
            padding:
                EdgeInsets.only(bottom: screenWidth * 0.2), // Adjust padding
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
                            margin: EdgeInsets.only(
                              top: screenWidth * 0.3, // Adjust margin
                              bottom: screenWidth * 0.04, // Adjust margin
                              left: screenWidth * 0.04, // Adjust margin
                              right: screenWidth * 0.04, // Adjust margin
                            ),
                            width: screenWidth * 0.6, // Adjust width
                            child: Image.asset('assets\\images\\Logo.png'),
                          ),
                          SizedBox(
                              height: screenWidth * 0.08), // Adjust spacing
                          SmoothPageIndicator(
                            onDotClicked: (index) => _controller.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeIn,
                            ),
                            effect: WormEffect(
                              dotColor: Colors.black26,
                              spacing: screenWidth * 0.04, // Adjust spacing
                              activeDotColor: logoColors[1]!,
                              dotWidth: screenWidth * 0.02, // Adjust size
                              dotHeight: screenWidth * 0.02, // Adjust size
                            ),
                            controller: _controller,
                            count: _numPages,
                          ),
                          SizedBox(
                              height: screenWidth * 0.08), // Adjust spacing
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
        margin: EdgeInsets.all(screenWidth * 0.02), // Adjust margin
        decoration: BoxDecoration(
          color: logoColors[1]!,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
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
