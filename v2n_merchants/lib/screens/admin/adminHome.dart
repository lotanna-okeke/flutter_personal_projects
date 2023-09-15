import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/screens/admin/merchant%20list/merchant_list.dart';
import 'package:v2n_merchants/screens/admin/new_merchant.dart';
import 'package:v2n_merchants/widgets/admin_drawer.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  List<Merchant> _merchants = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItmes();
  }

  void _loadItmes() async {
    final url =
        Uri.https('v2n-merchant-default-rtdb.firebaseio.com', 'merchants.json');
    ;

    try {
      final response = await http.get(url);
      setState(() {
        if (response.statusCode >= 400) {
          _error = "Failed to fetch data. Please try again later.";
        }
      });

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final List<Merchant> loadedMerchants = [];

      final Map<String, dynamic> listMerchant = json.decode(response.body);

      for (final merchant in listMerchant.entries) {
        loadedMerchants.add(
          Merchant(
            id: merchant.key,
            name: merchant.value['name'],
            email: merchant.value['email'],
            password: merchant.value['password'],
            airtimeId: merchant.value['airtimeId'],
            dataId: merchant.value['dataId'],
            b2bId: merchant.value['b2bId'],
            portalId: merchant.value['portalId'],
            portalPassword: merchant.value['portalPassword'],
            isActive: merchant.value['active'],
          ),
        );
      }
      setState(() {
        _merchants = loadedMerchants;
        // ref
        //     .read(MerchantHandlerProvider.notifier)
        //     .loadMerchants(loadedMerchants);
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _error = "Something went wrong. Please try again later.";
      });
    }
  }

  void _addMerchant() async {
    final newMerchant = await Navigator.push<Merchant>(
      context,
      MaterialPageRoute(
        builder: (ctx) => NewMerchant(),
      ),
    );
    if (newMerchant == null) {
      return;
    }
    setState(() {
      _merchants.add(newMerchant);
    });
  }

  void deleteMerchant(Merchant merchant) async {
    final merchantIndex = _merchants.indexOf(merchant);
    setState(() {
      _merchants.remove(merchant);
    });
    final url = Uri.https('v2n-merchant-default-rtdb.firebaseio.com',
        'merchants/${merchant.id}.json');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            "${merchant.name} Deleted",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "Invalid URL",
            textAlign: TextAlign.center,
          ),
        ),
      );
      setState(() {
        _merchants.insert(merchantIndex, merchant);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _merchants = ref.watch(MerchantHandlerProvider);
    // });
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You got no items yet',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Add an item with the add icon by the top right',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    if (_merchants.isNotEmpty) {
      content = Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    child: Expanded(
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: logoColors[1],
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: logoColors[1],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MerchantList(
                merchants: _merchants,
                onRemoveMerchant: deleteMerchant,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      // backgroundColor: logoColors[2],
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'VasAdmin',
        ),
        backgroundColor: logoColors[1]!.withOpacity(0.9),
      ),
      drawer: const AdminDrawer(),
      body: content,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: logoColors[1],
        onPressed: _addMerchant,
        child: const Icon(Icons.add),
      ),
    );
  }
}
