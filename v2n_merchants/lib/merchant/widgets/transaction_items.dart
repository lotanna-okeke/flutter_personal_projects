import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/widgets/transaction_details.dart';
import 'package:v2n_merchants/models/merchant.dart';

class TransactionItems extends StatelessWidget {
  const TransactionItems({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final FetchTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final date = formatDate(transaction.dateCreated!);
    final _isSuccess = transaction.isSuccessful;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.primary,
        surfaceTintColor: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionDetails(transaction: transaction),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2, // Allocate 2/3 of the available space
                      child: Text(
                        '₦${formatStringNumberWithCommas(transaction.amount)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1, // Allocate 1/3 of the available space
                      child: Text(
                        '${date}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2, // Allocate 2/3 of the available space
                      child: Text(
                        '${transaction.billerDescription}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1, // Allocate 1/3 of the available space
                      child: Text(
                        '${transaction.status}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isSuccess! ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
