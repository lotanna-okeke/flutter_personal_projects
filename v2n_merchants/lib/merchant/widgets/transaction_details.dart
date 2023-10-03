import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/widgets/detail_items.dart';
import 'package:v2n_merchants/models/merchant.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({
    super.key,
    required this.transaction,
  });

  final FetchTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final date = formatDate(transaction.dateCreated!);
    final time = formatTime(transaction.dateCreated!);
    final _isSuccess = transaction.isSuccessful;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   transaction.status!,
                    //   style: TextStyle(
                    //     fontSize: 28,
                    //     color: _isSuccess! ? Colors.green : Colors.red,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Date\n ${date}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Text(
                          'Time\n ${time}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Card(
                    //   // color:
                    //   //     Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    //   child: Padding(
                    //     padding: EdgeInsets.all(10),
                    //     child: Expanded(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           TransactionDetailItems(
                    //               name: transaction.billerCategory!,
                    //               title: "Biller Category"),
                    //           TransactionDetailItems(
                    //               name: transaction.billerDescription!,
                    //               title: "Biller Description"),
                    //           TransactionDetailItems(
                    //               name: transaction.billerId!,
                    //               title: "Biller ID"),
                    //           TransactionDetailItems(
                    //               name: transaction.commission!,
                    //               title: "Commission"),
                    //           TransactionDetailItems(
                    //               name: transaction.customerId!,
                    //               title: "Customer ID"),
                    //           TransactionDetailItems(
                    //               name: transaction.referenceId!,
                    //               title: "Reference ID"),
                    //           TransactionDetailItems(
                    //               name: transaction.requestId,
                    //               title: "Request ID"),
                    //           TransactionDetailItems(
                    //               name: transaction.reversed!,
                    //               title: "Reversed"),
                    //           TransactionDetailItems(
                    //               name: transaction.walletDescription!,
                    //               title: "Wallet Description"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Amount\n ₦${transaction.amount}',
                    //       style: const TextStyle(
                    //         fontSize: 18,
                    //         color: Colors.black,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     const Spacer(),
                    //     Text(
                    //       'Previous Balance\n ₦${transaction.balanceBefore}',
                    //       style: const TextStyle(
                    //         fontSize: 18,
                    //         color: Colors.black,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransactionDetailItems(
                          name: transaction.billerCategory!,
                          title: "Biller Category"),
                      TransactionDetailItems(
                          name: transaction.billerDescription!,
                          title: "Biller Description"),
                      TransactionDetailItems(
                          name: transaction.billerId!, title: "Biller ID"),
                      TransactionDetailItems(
                          name: transaction.commission!, title: "Commission"),
                      TransactionDetailItems(
                          name: transaction.customerId!, title: "Customer ID"),
                      TransactionDetailItems(
                          name: transaction.referenceId!,
                          title: "Reference ID"),
                      TransactionDetailItems(
                          name: transaction.requestId, title: "Request ID"),
                      TransactionDetailItems(
                          name: transaction.reversed!, title: "Reversed"),
                      TransactionDetailItems(
                          name: transaction.walletDescription!,
                          title: "Wallet Description"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Amount\n ₦${formatStringNumberWithCommas(transaction.amount)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      'Previous Balance\n ₦${formatStringNumberWithCommas(transaction.balanceBefore)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
