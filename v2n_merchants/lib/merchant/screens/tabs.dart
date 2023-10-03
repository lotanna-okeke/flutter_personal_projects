import 'package:flutter/material.dart';
import 'package:v2n_merchants/merchant/screens/airtime.dart';
import 'package:v2n_merchants/merchant/screens/b2b.dart';
import 'package:v2n_merchants/merchant/screens/data.dart';
import 'package:v2n_merchants/merchant/screens/merchantHome.dart';
import 'package:v2n_merchants/merchant/widgets/merchant_drawer.dart';

const appBarTitles = ["B2B", "AIRTIME", "DATA"];

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
  });

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = MerchantHomeScreen(
      changeTab: (pageIndex) {
        setState(() {
          _selectedPageIndex = pageIndex;
        });
      },
    );

    switch (_selectedPageIndex) {
      case 1:
        activePage = B2BScreen();
        break;
      case 2:
        activePage = AirtimeScreen();
        break;
      case 3:
        activePage = DataScreen();
        break;
      default:
        break;
    }

    return Scaffold(
      appBar: (_selectedPageIndex == 0)
          ? AppBar(
              title: const Row(
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              // centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                Row(
                  children: [
                    Image.asset(
                      'assets\\images\\Logo.png',
                      width: 60,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            )
          : AppBar(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
              foregroundColor: Colors.white,
              title: Text(appBarTitles[_selectedPageIndex - 1]),
            ),
      body: activePage,
      drawer: MerchantDrawer(
        changeTab: (pageIndex) {
          setState(() {
            _selectedPageIndex = pageIndex;
          });
        },
      ),

      // backgroundColor: const Color.fromARGB(255, 68, 65, 65),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 20,
        // fixedColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'B2B',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Airtime',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Data',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
