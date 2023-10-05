import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:v2n_merchants/merchant/widgets/transaction_items.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';

class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({
    super.key,
  });

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  String username = "";
  List<FetchTransaction> transactions = [];

  bool _isConnected = true;
  String _error = "";
  bool _isError = false;
  bool _isLoading = true;

  void checkConnection() async {
    Timer.periodic(Duration(seconds: 15), (timer) {
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

  void _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });
    checkConnection();

    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-transactionLogs?page=1&pageSize=10');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "username": username,
          "filter": "data",
        },
      ),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<FetchTransaction> loadedTransactions = [];
      final logs = body['logs'];
      for (final log in logs) {
        loadedTransactions.add(
          FetchTransaction(
            amount: log['amount'],
            balanceBefore: log['balanceBefore'],
            billerCategory: log['billerCategory'],
            billerDescription: log['billerDescription'],
            billerId: log['billerId'],
            commission: log['commission'],
            customerId: log['customerId'],
            dateCreated: log['dateCreated'],
            extraInfo: log['extraInfo'],
            referenceId: log['referenceId'],
            requestId: log['requestId'],
            reversed: log['reversed'],
            status: log['status'],
            walletDescription: log['walletDescription'],
            isSuccessful: (log['status'] == 'Success'),
          ),
        );
      }
      setState(() {
        transactions = loadedTransactions;
        _error = "";
        _isError = false;
        _isLoading = false;
      });
      if (transactions.isEmpty) {
        setState(() {
          _error = "No Transaction History";
          _isError = true;
        });
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    username = ref.read(MerchantHandlerProvider)[0];
    super.initState();
    _loadTransactions();
  }

  Future _refresh() async {
    setState(() {
      _isLoading = true;
      _isConnected = true;
      username = ref.read(MerchantHandlerProvider)[0];
    });
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: transactions.length, // Replace with your item count
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          // return ListTile(
          //   title: Text(transaction.amount),
          // );
          return TransactionItems(transaction: transaction);
        },
      ),
    );

    if (_isError) {
      content = Center(
          child: Text(
        _error,
        style: const TextStyle(
          color: Colors.black,
        ),
      ));
    }

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (!_isConnected) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'Please connect to the internet',
            style: TextStyle(color: Colors.black),
          ),
          // const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              _refresh();
            },
            child: const Text('Refresh'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.all(20),
          child: (_isError || _isLoading)
              ? null
              : Text(
                  'Data History',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 25,
                  ),
                ),
        ),
        Expanded(child: content),
      ],
    );
  }
}
