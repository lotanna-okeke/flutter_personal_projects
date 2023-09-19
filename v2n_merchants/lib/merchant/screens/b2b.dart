import 'package:flutter/material.dart';

class B2BScreen extends StatefulWidget {
  const B2BScreen({super.key});

  @override
  State<B2BScreen> createState() => _B2BScreenState();
}

class _B2BScreenState extends State<B2BScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B2B'),
      ),
    );
  }
}
