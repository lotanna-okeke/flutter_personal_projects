import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/admin/screens/adminHome.dart';
import 'package:v2n_merchants/admin/screens/new_merchant.dart';
import 'package:v2n_merchants/merchant/screens/merchantHome.dart';
import 'package:v2n_merchants/merchant/screens/tabs.dart';
import 'package:v2n_merchants/screens/welcome.dart';
import 'package:v2n_merchants/test.dart';

void main() {
  // // Lock the orientation to portrait mode.
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setPreferredOrientations([DeviceOrientation.f])
  // runApp(
  //   const ProviderScope(child: MyApp()),
  // );

  WidgetsFlutterBinding.ensureInitialized();
  // Lock the orientation to portrait mode.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const ProviderScope(child: MyApp()),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      // home: CheckInternetConnection(),
      // home: const TabsScreen(),
    );
  }
}
