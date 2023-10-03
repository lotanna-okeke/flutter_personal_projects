import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/merchant/screens/new_sub_merchant.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';
import 'package:v2n_merchants/screens/login.dart';

class MerchantDrawer extends ConsumerWidget {
  const MerchantDrawer({
    super.key,
    required this.changeTab,
  });

  final void Function(int pageIndex) changeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isSubMerchant =
        ref.read(MerchantHandlerProvider.notifier).isSubMerchant();
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
                changeTab(0);
              },
            ),
            SizedBox(
              height: 2,
              width: double.infinity,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            _isSubMerchant
                ? const SizedBox(width: 0)
                : ListTile(
                    title: Text(
                      'Create Merchant',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                          ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewSubMerchant(),
                        ),
                      );
                    },
                  ),
            _isSubMerchant
                ? const SizedBox(width: 0)
                : SizedBox(
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
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
