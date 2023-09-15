import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/screens/admin/admin.dart';
import 'package:v2n_merchants/screens/admin/adminHome.dart';
import 'package:v2n_merchants/screens/admin/new_merchant.dart';
import 'package:v2n_merchants/screens/welcome.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
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
          // brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 248, 248, 248),
      ),
      home: const AdminHomeScreen(),
      // home: const AdminScreen(),
      // home: const WelcomeScreen(),
    );
  }
}
