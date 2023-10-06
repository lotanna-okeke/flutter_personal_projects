import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/screens/new_sub_merchant.dart';
import 'package:v2n_merchants/merchant/widgets/balanceCard.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';

class MerchantHomeScreen extends ConsumerStatefulWidget {
  const MerchantHomeScreen({
    super.key,
    required this.changeTab,
  });

  final void Function(int pageIndex) changeTab;
  @override
  ConsumerState<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends ConsumerState<MerchantHomeScreen> {
  bool _isConnected = true;
  bool _isSubMerchant = false;

  List<String> details = [];
  bool _isLoading = true;

  double airtimeBalance = 0;
  double dataBalance = 0;
  double b2bBalance = 0;
  double totalBalance = 0;

  void checkConnection() async {
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (_isLoading) {
        // If _isLoading is still true after 30 seconds, perform an action.
        print(
            'Performing action because _isLoading is still true after 30 seconds.');
        setState(() {
          _isConnected = false;
        });

        // Stop the timer if the action should only be performed once.
        timer.cancel();
      } else {
        // If _isLoading becomes false before 30 seconds, cancel the timer.
        print(
            'Not Performing action because _isLoading is not still true after 30 seconds.');
        setState(() {
          _isConnected = true;
          _isLoading = false;
        });

        timer.cancel();
      }
    });
  }

  void _subMerchantChecker() {
    if (details[2] == "sub-merchant-admin") {
      setState(() {
        _isSubMerchant = true;
      });
    }
  }

  void fetchAirtimeBalance() async {
    setState(() {
      _isLoading = true;
    });
    checkConnection();

    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-airtimeBalance');

    Map<String, String> headers = {
      "Authorization": 'Bearer ${details[1]}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          "username": details[0],
        },
      ),
    );

    print(response.statusCode);

    final body = jsonDecode(response.body);
    final balance = body['balance'];
    // final output = int.parse(balance).toDouble();
    // print(balance);

    if (response.statusCode == 200) {
      // print(balance);
      setState(() {
        try {
          airtimeBalance = balance.toDouble();
        } catch (error) {
          try {
            if (balance.contains('.')) {
              airtimeBalance = double.parse(balance);
            } else {
              airtimeBalance = int.parse(balance).toDouble();
            }
          } catch (e) {
            // Handle parsing error if the input is not a valid number.
            airtimeBalance = 0.0;
          }
        }
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text(
            'Please logout and login again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void fetchDataBalance() async {
    setState(() {
      _isLoading = true;
    });
    checkConnection();
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-dataBalance');

    Map<String, String> headers = {
      "Authorization": 'Bearer ${details[1]}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          "username": details[0],
        },
      ),
    );

    final body = jsonDecode(response.body);
    final balance = body['balance'];
    if (response.statusCode == 200) {
      setState(() {
        try {
          dataBalance = balance.toDouble();
        } catch (error) {
          try {
            if (balance.contains('.')) {
              dataBalance = double.parse(balance);
            } else {
              dataBalance = int.parse(balance).toDouble();
            }
          } catch (e) {
            // Handle parsing error if the input is not a valid number.
            dataBalance = 0.0;
          }
        }
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text(
            'Please logout and login again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void fetchB2bBalance() async {
    setState(() {
      _isLoading = true;
    });
    checkConnection();
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-b2bBalance');

    Map<String, String> headers = {
      "Authorization": 'Bearer ${details[1]}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          "username": details[0],
        },
      ),
    );

    final body = jsonDecode(response.body);
    final balance = body['balance'];
    if (response.statusCode == 200) {
      setState(() {
        try {
          b2bBalance = balance.toDouble();
        } catch (error) {
          try {
            if (balance.contains('.')) {
              b2bBalance = double.parse(balance);
            } else {
              b2bBalance = int.parse(balance).toDouble();
            }
          } catch (e) {
            // Handle parsing error if the input is not a valid number.
            b2bBalance = 0.0;
          }
        }
        _isLoading = false;
      });
      print(b2bBalance);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text(
            'Please logout and login again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  //to fetch all the balances
  void fetchBalaces() async {
    //to fetch the airtime balances
    fetchAirtimeBalance();
    //fetch data balances
    fetchDataBalance();
    //fetch b2b balances
    fetchB2bBalance();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      totalBalance = airtimeBalance + dataBalance + b2bBalance;
    });
  }

  @override
  void initState() {
    checkConnection();

    //to get the name, password, and token of a user
    details = ref.read(MerchantHandlerProvider);
    //store the value of the balances in their variables
    fetchBalaces();
    _subMerchantChecker();

    super.initState();
  }

  Future _refresh() async {
    // print('object');
    setState(() {
      _isLoading = true;
      _isConnected = true;
    });
    initState();

    // fetchBalaces();
  }

  @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final largeScreen = screenWidth > 600;

  Widget content = Column(
    children: [
      GestureDetector(
        onTap: () {
          widget.changeTab(2);
        },
        child: BalanceCards(
          icon: Icons.call,
          title: 'Airtime',
          balance: airtimeBalance,
          fontSize: largeScreen ? 24.0 : 20.0,
        ),
      ),
      GestureDetector(
        onTap: () {
          widget.changeTab(3);
        },
        child: BalanceCards(
          icon: Icons.wifi,
          title: 'Data',
          balance: dataBalance,
          fontSize: largeScreen ? 24.0 : 20.0,
        ),
      ),
      GestureDetector(
        onTap: () {
          widget.changeTab(1);
        },
        child: BalanceCards(
          icon: Icons.work,
          title: 'B2B',
          balance: b2bBalance,
          fontSize: largeScreen ? 24.0 : 20.0,
        ),
      ),
    ],
  );

  if (_isLoading) {
    content = const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 100),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  if (!_isConnected) {
    content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 100),
          Text(
            'Please connect to the internet',
            style: TextStyle(
              color: Colors.black,
              fontSize: largeScreen ? 24.0 : 20.0,
            ),
          ),
          TextButton(
              onPressed: () {
                _refresh();
              },
              child: Text(
                'Refresh',
                style: TextStyle(
                  fontSize: largeScreen ? 24.0 : 20.0,
                ),
              ))
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: _refresh,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shadowColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
            elevation: 40,
            margin: EdgeInsets.symmetric(
                horizontal: largeScreen ? 30 : 10), // Adjust margins
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )),
                height: (MediaQuery.of(context).size.height) / (largeScreen ? 3.0 : 2.5), // Adjust height
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
                      const Icon(
                        Icons.portrait_outlined,
                        size: 60,
                      ),
                      Text(
                        'Hello, ${details[0]}',
                        style: TextStyle(
                          fontSize: largeScreen ? 28.0 : 25.0,
                        ),
                      ),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: largeScreen ? 24.0 : 20.0,
                        ),
                      ),
                      Text(
                        (_isLoading || !_isConnected)
                            ? "..."
                            : '₦ ${formatNumberWithCommas(totalBalance)}',
                        style: TextStyle(
                          fontSize: largeScreen ? 40.0 : 35.0,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
            //Secon Container for the newUser buttom
            _isSubMerchant
                ? const SizedBox(height: 30)
                : Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewSubMerchant(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'New User',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Balances',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 35,
                ),
              ),
            ),
            //Container for all the balances
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(
                  top: 0, bottom: 20, left: 20, right: 20),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
