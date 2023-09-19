import 'package:flutter/material.dart';
import 'package:v2n_merchants/merchant/screens/b2b.dart';
import 'package:v2n_merchants/merchant/screens/merchantHome.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

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
    Widget activePage = const MerchantHomeScreen();

    if (_selectedPageIndex == 1) {
      activePage = const B2BScreen();
    }

    return Scaffold(
      body: activePage,

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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'B2B',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Airtime',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Data',
          ),
        ],
      ),
    );
  }
}