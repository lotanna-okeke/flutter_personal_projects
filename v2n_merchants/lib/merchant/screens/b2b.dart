import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/data.dart';
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

  void _loadTransaction() async {
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
      });
      if (transactions.isEmpty) {
        setState(() {
          _error = "No Transaction History";
        });
        return;
      }
      print(transactions[0].amount);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    username = ref.read(MerchantHandlerProvider)[0];
    filters = ref.read(FilterHandlerProvider);
    super.initState();
    _selectedFilter = filters[0];
    _loadTransaction();
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
    // );
    // Widget content = SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       for (final transaction in transactions)
    //         ListTile(
    //           title: Text(
    //             transaction.amount,
    //             style: TextStyle(color: Colors.red),
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    if (_error != "") {
      content = Center(
          child: Text(
        _error,
        style: const TextStyle(
          color: Colors.black,
        ),
      ));
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
                    _loadTransaction();
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
        // Expanded(
        //   child: RefreshIndicator(
        //     onRefresh: _refresh,
        //     backgroundColor: Theme.of(context).colorScheme.primary,
        //     color: Theme.of(context).colorScheme.onPrimary,
        //     child: ListView(
        //       shrinkWrap:
        //           true, // Set to true to make ListView work inside Column
        //       children: transactions.map((transaction) {
        //         return Text('data'); // Replace with your transaction data
        //       }).toList(),
        //     ),
        //   ),
        // ),

        Expanded(child: content),

        // Container(
        //   margin: EdgeInsets.all(20),
        //   // alignment: Alignment.center,
        //   child: content,
        // )
        // Container(
        //   margin: EdgeInsets.all(20),
        //   color: Colors.green,
        //   child: Column(
        //     children: [
        //       for (final transaction in transactions) Text(transaction.amount),
        //       ListView(
        //         children: transactions.map((transaction) {
        //           return Text('data'); // Replace with your transaction data
        //         }).toList(),
        //       ),
        //     ],
        //   ),
        // )
        // Expanded(
        //   child: RefreshIndicator(
        //     onRefresh: _refresh,
        //     backgroundColor: Theme.of(context).colorScheme.primary,
        //     color: Theme.of(context).colorScheme.onPrimary,
        //     child: content,
        //   ),
        // ),
      ],
    );
  }
}
