import 'package:flutter/material.dart';
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/merchant/widgets/detail_items.dart';
import 'package:v2n_merchants/models/merchant.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final FetchTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final date = formatDate(transaction.dateCreated!);
    final time = formatTime(transaction.dateCreated!);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = EdgeInsets.all(screenWidth > 600 ? 16.0 : 8.0);
    final fontSize = screenWidth > 600 ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(screenWidth > 600 ? 60.0 : 30.0),
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
                padding: cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Date\n ${date}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Text(
                          'Time\n ${time}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                padding: cardPadding,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransactionDetailItems(
                        name: transaction.billerCategory!,
                        title: "Biller Category",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.billerDescription!,
                        title: "Biller Description",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.billerId!,
                        title: "Biller ID",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.commission!,
                        title: "Commission",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.customerId!,
                        title: "Customer ID",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.referenceId!,
                        title: "Reference ID",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.requestId,
                        title: "Request ID",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.reversed!,
                        title: "Reversed",
                        fontSize: fontSize,
                      ),
                      TransactionDetailItems(
                        name: transaction.walletDescription!,
                        title: "Wallet Description",
                        fontSize: fontSize,
                      ),
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
                padding: cardPadding,
                child: Row(
                  children: [
                    Text(
                      'Amount\n ₦${formatStringNumberWithCommas(transaction.amount)}',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      'Previous Balance\n ₦${formatStringNumberWithCommas(transaction.balanceBefore)}',
                      style: TextStyle(
                        fontSize: fontSize,
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
