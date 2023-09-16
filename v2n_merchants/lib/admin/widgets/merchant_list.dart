import 'package:flutter/material.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/admin/widgets/merchant_item.dart';

class MerchantList extends StatefulWidget {
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
  State<MerchantList> createState() => _MerchantListState();
}

class _MerchantListState extends State<MerchantList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.merchants.length,
      itemBuilder: (context, index) => MerchantItem(
        merchant: widget.merchants[index],
        onRemoveMerchant: widget.onRemoveMerchant,
        onEditMerchant: widget.onEditMerchant,
      ),
    );
  }
}
