import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';

class TermOfUse extends StatefulWidget {
  const TermOfUse({super.key});

  @override
  State<TermOfUse> createState() => _TermOfUseState();
}

class _TermOfUseState extends State<TermOfUse> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: logoColors[3],
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              'Terms of Use',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: logoColors[2],
              ),
            ),
            const Text(
              '1. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              '2. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              '3. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              'Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: logoColors[2],
              ),
            ),
            const Text(
              '1. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              '2. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              '3. Acceptance of Terms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'By accessing or using the services provided by [Company Name], you agree to comply with and be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
