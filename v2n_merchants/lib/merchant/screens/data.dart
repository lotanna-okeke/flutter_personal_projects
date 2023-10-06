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

  // to control the buttons at the bottom
  bool _isFirstPage = false;
  bool _isLastPage = false;
  bool _noPagination = false;

  int _currentPage = 1;
  double _totalPages = 1;
  int pageSize = 10;

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

  void setButtons(int page) {
    if (page == (_totalPages.toInt()) + 1) {
      setState(() {
        _isLastPage = true;
      });
      return;
    }
    if (page == 1) {
      print(page);
      setState(() {
        _isFirstPage = true;
      });
      return;
    }
    setState(() {
      _isFirstPage = false;
      _isLastPage = false;
    });
  }

  void _loadTransactions(int page) async {
    setState(() {
      _isLoading = true;
      _noPagination = false;
    });
    checkConnection();

    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-transactionLogs?page=$page&pageSize=$pageSize');
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
      setState(() {
        _totalPages = int.parse(body['filteredRecordCount']) / pageSize;
        if ((_totalPages.toInt()) == 0) {
          _noPagination = true;
        }
      });
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

  void _loadNextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      _loadTransactions(_currentPage);
      setButtons(_currentPage);
    }
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      _loadTransactions(_currentPage);
      setButtons(_currentPage);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    username = ref.read(MerchantHandlerProvider)[0];
    super.initState();
    _loadTransactions(_currentPage);
    setButtons(_currentPage);
  }

  Future _refresh() async {
    setState(() {
      _isLoading = true;
      _isConnected = true;
      username = ref.read(MerchantHandlerProvider)[0];
    });
    _loadTransactions(_currentPage);
    setButtons(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    Widget controlButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _loadPreviousPage,
          child: Text('Previous'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: _loadNextPage,
          child: Text('Next'),
        ),
      ],
    );

    if (_noPagination) {
      controlButtons = const Center();
    }

    if (_isFirstPage && !_noPagination) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadNextPage,
          child: Text('Next'),
        ),
      );
    }

    if (_isLastPage && !_noPagination) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadPreviousPage,
          child: Text('Previous'),
        ),
      );
    }

    Widget content = RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Expanded(
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
          ),
          controlButtons,
        ],
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
                  'Transaction History',
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
