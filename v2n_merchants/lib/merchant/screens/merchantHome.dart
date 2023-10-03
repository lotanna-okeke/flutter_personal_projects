import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/data.dart';
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
  List<String> details = [];
  double airtimeBalance = 0;
  double dataBalance = 0;
  double b2bBalance = 0;
  double totalBalance = 0;
  bool _isLoading = true;
  bool _isSubMerchant = false;

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
      // _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
    });
    initState();

    // fetchBalaces();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //First container for the top of the screen
            Card(
              shadowColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
              // shape: CircleBorder(eccentricity: 0),
              elevation: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              // clipBehavior: Clip.hardEdge,
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
                        const Icon(
                          Icons.portrait_outlined,
                          size: 60,
                        ),
                        Text(
                          'Hello, ${details[0]}',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const Text(
                          'Your Balances',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          _isLoading
                              ? "..."
                              : '₦ ${formatNumberWithCommas(totalBalance)}',
                          style: TextStyle(
                            fontSize: 35,
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
                        print(details[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewSubMerchant(),
                          ),
                        );
                        fetchBalaces();
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
            //Container for all the balances
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(
                  top: 0, bottom: 20, left: 20, right: 20),
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
                    child: _isLoading
                        ? const SizedBox(height: 100)
                        : BalanceCards(
                            icon: Icons.call,
                            title: 'Airtime',
                            balance: airtimeBalance,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changeTab(3);
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : BalanceCards(
                            icon: Icons.wifi,
                            title: 'Data',
                            balance: dataBalance,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changeTab(1);
                    },
                    child: _isLoading
                        ? const Text("")
                        : BalanceCards(
                            icon: Icons.work,
                            title: 'B2B',
                            balance: b2bBalance,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
