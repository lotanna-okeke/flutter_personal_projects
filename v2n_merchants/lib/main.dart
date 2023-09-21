import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/admin/screens/adminHome.dart';
import 'package:v2n_merchants/admin/screens/new_merchant.dart';
import 'package:v2n_merchants/merchant/screens/merchantHome.dart';
import 'package:v2n_merchants/merchant/screens/tabs.dart';
import 'package:v2n_merchants/screens/welcome.dart';
import 'package:v2n_merchants/test.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAS2Nets',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: logoColors[1]!,
          onSurface: Color.fromARGB(255, 100, 1, 1),
          // brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      // home: const AdminHomeScreen(),
      home: const WelcomeScreen(),
      // home: const Test(),
      // home: const TabsScreen(),
    );
  }
}
