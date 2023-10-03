import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/widgets/transaction_details.dart';
import 'package:v2n_merchants/models/merchant.dart';

class TransactionItems extends StatelessWidget {
  const TransactionItems({
    super.key,
    required this.transaction,
  });

  final FetchTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final date = formatDate(transaction.dateCreated!);
    final _isSuccess = transaction.isSuccessful;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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
        child: Card(
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.primary,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('₦${formatStringNumberWithCommas(transaction.amount)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 30,
                        )),
                    const Spacer(),
                    Text('${date}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 25,
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${transaction.billerDescription}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '${transaction.status}',
                        style: TextStyle(
                            fontSize: 20,
                            color: _isSuccess! ? Colors.green : Colors.red),
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
