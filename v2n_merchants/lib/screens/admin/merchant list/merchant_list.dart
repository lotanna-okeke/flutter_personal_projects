import 'package:flutter/material.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/screens/admin/merchant%20list/merchant_item.dart';

class MerchantList extends StatelessWidget {
  const MerchantList({
    super.key,
    required this.merchants,
    required this.onRemoveMerchant,
  });

  final List<Merchant> merchants;
  final Function(Merchant merchant) onRemoveMerchant;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: merchants.length,
      itemBuilder: (context, index) => MerchantItem(
        merchant: merchants[index],
        onRemoveMerchant: onRemoveMerchant,
      ),
    );
  }
}
