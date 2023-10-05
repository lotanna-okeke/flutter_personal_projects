import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';

class NewSubMerchant extends ConsumerStatefulWidget {
  const NewSubMerchant({
    super.key,
  });

  @override
  ConsumerState<NewSubMerchant> createState() => _NewSubMerchantState();
}

class _NewSubMerchantState extends ConsumerState<NewSubMerchant> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  bool _isConnected = true;
  bool _obscureText = true;

  String error = "";

  String _name = '';
  String _email = '';
  String _password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void displayNoInternet() async {
    setState(() {
      error = "Please connet to the internet";
      _isSending = false;
    });

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      error = "";
    });
  }

  void checkConnection() async {
    Timer.periodic(Duration(seconds: 15), (timer) {
      if (_isSending) {
        // If _isSending is still true after 30 seconds, perform an action.
        // print(
        //     'Performing action because _isSending is still true after 30 seconds.');
        setState(() {
          _isConnected = false;
        });

        // Stop the timer if the action should only be performed once.
        timer.cancel();
        displayNoInternet();
      } else {
        // If _isSending becomes false before 30 seconds, cancel the timer.
        // print(
        //     'Not Performing action because _isSending is not still true after 30 seconds.');
        setState(() {
          _isConnected = true;
          _isSending = false;
        });
        timer.cancel();
        return;
      }
    });
    // if (!_isConnected) {
    await Future.delayed(const Duration(seconds: 15));
    // }
    setState(() {
      _isSending = false;
    });
  }

  void _createMerchant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });
      checkConnection();

      final token = ref.read(MerchantHandlerProvider)[1];

      final url = Uri.parse(
          'http://132.226.206.68/vaswrapper/jsdev/clientmanager/create-subMerchant');
      Map<String, String> headers = {
        "Authorization": 'Bearer $token',
      };
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "name": _name,
          "username": _email,
          "password": _password,
        }),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Created'),
            content: const Text('SubMerchant created Successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Okay',
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
      print(response.body);
      final body = jsonDecode(response.body)['message'];
      if (body == "Maximum limit reached! Please contact admin.") {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Limit'),
            content:
                const Text('Maximum limit of 3 reached! Please contact admin.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Okay',
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }

      // else {
      //   print(response.body['message']);
      // }
    }
    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Sub Merchant'),
        backgroundColor: logoColors[1]!.withOpacity(0.8),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Center(
          child: Stack(
            children: [
              Image.asset(
                'assets\\images\\Logo.png',
                width: double.infinity,
                // height: (double.infinity - 200 as double),
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
                child: SingleChildScrollView(
                  child: Card(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              initialValue: _name,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: 'Company Name',
                                  hintText: 'VAS2Nets Technologies',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.7))),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _name = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              initialValue: _email,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'john123@gmail.com',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                final validEmail =
                                    RegExp("^[a-zA-Z0-9+_.-]+@[a-z]+.[a-z]");
                                if (!(value!.contains(validEmail))) {
                                  return "Invalid email address";
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _email = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Must contain at least 6 chararcters";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _password = newValue!;
                              },
                            ),
                            const SizedBox(height: 10),
                            (error.isEmpty)
                                ? const SizedBox(height: 0)
                                : Container(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        '$error',
                                        style: TextStyle(
                                          color: logoColors[1],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: _isSending
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _createMerchant,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: logoColors[1],
                                      ),
                                      child: const Text(
                                        'Create',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
