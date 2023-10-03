import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantHandlerNotifier extends StateNotifier<List<String>> {
  MerchantHandlerNotifier() : super(const ["name", "token", "role"]);

  void loadMerchants(List<String> merchantDetails) {
    state = merchantDetails;
  }

  bool isSubMerchant() {
    if (state[2] == "sub-merchant-admin") {
      return true;
    }
    return false;
  }
}

final MerchantHandlerProvider =
    StateNotifierProvider<MerchantHandlerNotifier, List<String>>(
        (ref) => MerchantHandlerNotifier());

class FilterHandlerNotifier extends StateNotifier<List<String>> {
  FilterHandlerNotifier() : super(const ["name"]);

  void loadFilters(String name) async {
    // await Future.delayed(Duration(seconds: 10));
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-allBillerCategories');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "username": name,
        },
      ),
    );

// {"data":{"status":200,"data":{"categories":[{"id":"kyc","name":"Know Your Customer (Validation Services)"},
//{"id":"disco","name":"Electricity Distribution"},{"id":"tv","name":"Satellite Television (Multichoice Network)"},{"id":"bet","name":"Betting and\/or Lottery"},{"id":"education","name":"Educational"},{"id":"internet","name":"Internet Subscription"},{"id":"banking","name":"Banking Operation"},{"id":"vtu","name":"Virtual TopUp"}]},"description":"request has been processed"},"status":200}
    final body = jsonDecode(response.body);
    final categories = body['data']['data']['categories'];
    print(categories);
    List<String> ids = [];
    if (response.statusCode == 200) {
      // setState(() {
      for (final id in categories) {
        ids.add(id['id']);
        print(id['id']);
      }
      // });
      // setState(() {
      //   filters = ids;
      // });
    }
    state = ids;
    // setState(() {
    //   filters = ids;
    // });
  }
}

final FilterHandlerProvider =
    StateNotifierProvider<FilterHandlerNotifier, List<String>>(
        (ref) => FilterHandlerNotifier());
