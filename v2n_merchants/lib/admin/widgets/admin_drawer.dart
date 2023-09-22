import 'package:flutter/material.dart';
import 'package:v2n_merchants/admin/screens/adminHome.dart';
import 'package:v2n_merchants/admin/screens/new_merchant.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    super.key,
    required this.token,
  });

  final String token;

  @override
  Widget build(BuildContext context) {
    final fullScreen = MediaQuery.of(context).size.width;

    return Drawer(
      width: fullScreen / 1.7,
      child: Container(
        // color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: DrawerHeader(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    'assets\\images\\VAS2Nets-Logo.png',
                    width: 50,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Dashboard',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 2,
              width: double.infinity,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              title: Text(
                'Create Merchant',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewMerchant(
                      token: token,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 2,
              width: double.infinity,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
