import 'package:flutter/material.dart';
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Container(
            // margin: EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets\\images\\Logo.png',
                  //   fit: BoxFit.cover,
                  //   width: 250,
                  // ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 100,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    width: 250,
                    child: Image.asset('assets\\images\\Logo.png'),
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    '. . .',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Help Your Business?',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      // color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Become a merchant and watch your operations become easier ;)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: logoColors[1],
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const LoginScreen())));
          },
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                // color: Theme.of(context).colorScheme.primaryContainer,
                // fontFamily: FontFamily
                ),
            textAlign: TextAlign.center,
          ),
        ),
        // child: Container(
        //   margin: EdgeInsets.all(20),
        //   child: TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       'Login',
        //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //             color: Theme.of(context).colorScheme.primaryContainer,
        //           ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
