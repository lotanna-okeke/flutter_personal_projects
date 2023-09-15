import 'package:flutter/material.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/admin/widgets/merchant_item.dart';

class MerchantList extends StatelessWidget {
  const MerchantList({
    super.key,
    required this.merchants,
    required this.onRemoveMerchant,
    required this.onEditMerchant,
  });

  final List<Merchant> merchants;
  final Function(Merchant merchant) onRemoveMerchant;
  final Function(Merchant merchant) onEditMerchant;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: merchants.length,
      itemBuilder: (context, index) => MerchantItem(
        merchant: merchants[index],
        onRemoveMerchant: onRemoveMerchant,
        onEditMerchant: onEditMerchant,
      ),
    );
  }
}
