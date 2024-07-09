import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/screens/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final fullScreen = MediaQuery.of(context).size.width;
    return Drawer(
      width: fullScreen / 2.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Implement logout functionality here
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AuthScreen()));
                print('tester');
                // Navigator.pop(context); // Close the drawer
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
