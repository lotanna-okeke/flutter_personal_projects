import 'package:flutter/material.dart';
import 'package:v2n_merchants/merchant/widgets/balanceCard.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({
    super.key,
    required this.changeTab,
  });

  final void Function(int pageIndex) changeTab;
  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //First container for the top of the screen
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )),
            height: (MediaQuery.of(context).size.height) / 3.0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.portrait_outlined,
                        size: 60,
                      ),
                      Image.asset(
                        'assets\\images\\Logo.png',
                        width: 60,
                      ),
                    ],
                  ),
                  const Text(
                    'Hello, Stephen and Sons Limited',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    'Your Balances',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    '₦ 452,000',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            )),
        //Secon Container for the newUser buttom
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'New User',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
        //Container for all the balances
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Balances',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 35,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.changeTab(2);
                },
                child: const BalanceCards(
                    icon: Icons.call, title: 'Airtime', balance: 2000),
              ),
              GestureDetector(
                onTap: () {
                  widget.changeTab(3);
                },
                child: const BalanceCards(
                    icon: Icons.wifi, title: 'Data', balance: 50000),
              ),
              GestureDetector(
                onTap: () {
                  widget.changeTab(1);
                },
                child: const BalanceCards(
                    icon: Icons.work, title: 'B2B', balance: 400000),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
