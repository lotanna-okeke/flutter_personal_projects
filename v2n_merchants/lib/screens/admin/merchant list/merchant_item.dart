import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/providers/merchant_provier.dart';

class MerchantItem extends ConsumerStatefulWidget {
  const MerchantItem({
    super.key,
    required this.merchant,
    required this.onRemoveMerchant,
  });
  final Merchant merchant;
  final Function(Merchant merchant) onRemoveMerchant;

  @override
  ConsumerState<MerchantItem> createState() => _MerchantItemState();
}

class _MerchantItemState extends ConsumerState<MerchantItem> {
  Merchant? merchant;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    merchant = widget.merchant;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: merchant!.isActive
      //     ? Color.fromARGB(194, 7, 162, 56)
      //     : Color.fromARGB(118, 255, 0, 0),
      color: Colors.white,
      // color: Color.fromARGB(118, 255, 0, 0),
      // color: Theme.of(context).colorScheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${merchant!.name}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      color: Colors.black,
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        widget.onRemoveMerchant(merchant!);
                      },
                      color: Colors.black,
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  merchant!.email,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      merchant!.isActive = !merchant!.isActive;
                      ref
                          .read(MerchantHandlerProvider.notifier)
                          .changeActiveStatus(merchant!);
                    });
                  },
                  icon: Icon(merchant!.isActive ? Icons.thumb_up : Icons.block,
                      color: Colors.black),
                  label: Text(
                    merchant!.isActive ? 'Active' : 'Disabled',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: merchant!.isActive
                            ? Color.fromARGB(255, 50, 205, 50)
                            : Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
