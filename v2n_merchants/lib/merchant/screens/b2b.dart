import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/widgets/transaction_items.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';
import 'package:http/http.dart' as http;

class B2BScreen extends ConsumerStatefulWidget {
  const B2BScreen({
    super.key,
  });

  @override
  ConsumerState<B2BScreen> createState() => _B2BScreenState();
}

class _B2BScreenState extends ConsumerState<B2BScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  late List<String> filters;
  String _selectedFilter = "";
  List<FetchTransaction> transactions = [];

  String _error = "";
  bool _isloading = true;

  void _loadTransactions() async {
    setState(() {
      _isloading = true;
    });
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-transactionLogs?page=1&pageSize=10&b2bQuery=$_selectedFilter');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "username": username,
          "filter": "b2b",
        },
      ),
    );

    final body = jsonDecode(response.body);
    // print(body);
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
        _isloading = false;
      });
      if (transactions.isEmpty) {
        setState(() {
          _error = "No Transaction History";
        });
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    username = ref.read(MerchantHandlerProvider)[0];
    filters = ref.read(FilterHandlerProvider);
    super.initState();
    _selectedFilter = filters[0];
    _loadTransactions();
  }

  Future _refresh() async {}

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: transactions.length, // Replace with your item count
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        // return ListTile(
        //   title: Text(transaction.amount),
        // );
        return TransactionItems(transaction: transaction);
      },
    );

    if (_error != "") {
      content = Center(
          child: Text(
        _error,
        style: const TextStyle(
          color: Colors.black,
        ),
      ));
    }

    if (_isloading) {
      content = const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        //contains the dropdown and search button
        Container(
          // color: Colors.green,
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.white,
                    iconEnabledColor: Theme.of(context).colorScheme.primary,
                    value: _selectedFilter,
                    items: [
                      for (final filter in filters)
                        DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    _loadTransactions();
                    // String date = formatDate('06-SEP-23 01.44.37.453904 PM');
                    // String time = formatTime('06-SEP-23 01.44.37.453904 PM');
                    // print(date + '\t' + time);
                  },
                  child: Text("Search"),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Expanded(child: content),
      ],
    );
  }
}
