import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v2n_merchants/models/merchant.dart';

class MerchantHandlerNotifier extends StateNotifier<List<Merchant>> {
  MerchantHandlerNotifier() : super(const []);

  void loadMerchants(List<Merchant> merchants) {
    state = merchants;
  }

  void createMerchant(Merchant merchant) async {
    final url =
        Uri.https('v2n-merchant-default-rtdb.firebaseio.com', 'merchants.json');

    await http.post(
      url,
      headers: {'Contain-Type': 'application/json'},
      body: jsonEncode(
        {
          'name': merchant.name,
          'email': merchant.email,
          "password": merchant.password,
          "airtimeId": merchant.airtimeId,
          'dataId': merchant.dataId,
          'b2bId': merchant.b2bId,
          'portalId': merchant.portalId,
          'portalPassword': merchant.portalPassword,
          'active': true,
        },
      ),
    );
  }

  void addMerchant(Merchant merchant) {
    state = [...state, merchant];
  }

  void changeActiveStatus(Merchant merchant) async {
    final url = Uri.https('v2n-merchant-default-rtdb.firebaseio.com',
        'merchants/${merchant.id}.json');
    final response = await http.patch(
      url,
      body: json.encode(
        {
          'active': merchant.isActive,
        },
      ),
    );

    print(response.statusCode);
  }

  void deleteMerchant(List<Merchant> merchants) async {
    // final output = List.of(state);
    // output.removeWhere((element) => element.id != merchant.id);
    // print(output[0].name);
    state = merchants;
    // state = [merchant, ...state];
  }
}

final MerchantHandlerProvider =
    StateNotifierProvider<MerchantHandlerNotifier, List<Merchant>>(
        (ref) => MerchantHandlerNotifier());
