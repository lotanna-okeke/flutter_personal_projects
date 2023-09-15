import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/models/merchant.dart';

class NewMerchant extends StatefulWidget {
  const NewMerchant({
    super.key,
    this.merchant,
  });

  final Merchant? merchant;

  @override
  State<NewMerchant> createState() => _NewMerchantState();
}

class _NewMerchantState extends State<NewMerchant> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  var _name = '';
  var _email = '';
  var _password = '';
  var _airtime = '';
  var _data = '';
  var _b2b = '';
  var _portalId = '';
  var _portalPassword = '';
  Merchant? merchant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.merchant != null) {
      _isEditing = true;
      merchant = widget.merchant;
      _name = merchant!.name;
      _email = merchant!.email;
      _password = merchant!.password;
      _airtime = merchant!.airtimeId;
      _data = merchant!.dataId;
      _b2b = merchant!.b2bId;
      _portalId = merchant!.portalId;
      _portalPassword = merchant!.portalPassword;
    }
  }

  void _createMerchant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'v2n-merchant-default-rtdb.firebaseio.com', 'merchants.json');

      final response = await http.post(
        url,
        headers: {'Contain-Type': 'application/json'},
        body: jsonEncode(
          {
            'name': _name,
            'email': _email,
            "password": _password,
            "airtimeId": _airtime,
            'dataId': _data,
            'b2bId': _b2b,
            'portalId': _portalId,
            'portalPassword': _portalPassword,
            'active': true,
          },
        ),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);

      if (!context.mounted) {
        return;
      }

      final merchant = Merchant(
        id: resData['name'],
        name: _name,
        email: _email,
        password: _password,
        airtimeId: _airtime,
        dataId: _data,
        b2bId: _b2b,
        portalId: _portalId,
        portalPassword: _portalPassword,
        isActive: true,
      );

      // ref.read(MerchantHandlerProvider.notifier).addMerchant(merchant);

      Navigator.pop(
        context,
        merchant,
      );
    }
  }

  void _editMerchant() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isEditing ? 'Edit Merchant' : 'Create New Merchant'),
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
                height: (double.infinity - 200 as double),
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
                                  hintText: _isEditing
                                      ? "${widget.merchant!.name}"
                                      : 'VAS2Nets Technologies',
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
                              decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: _isEditing
                                      ? widget.merchant!.email
                                      : 'john123@gmail.com',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.7))),
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
                                hintText:
                                    _isEditing ? widget.merchant!.password : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length < 6 ||
                                    !value.contains(RegExp(r'[A-Z]')) ||
                                    !value.contains(RegExp(r'[a-z]')) ||
                                    !value.contains(RegExp(r'[0-9]'))) {
                                  return "Must contain at least 6 chararcters with: \n.A number\n.A capital letter\n.A small letter";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _password = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Airtime-ID',
                                hintText: _isEditing
                                    ? widget.merchant!.airtimeId
                                    : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _airtime = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Data-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.dataId : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _data = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'B2B-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.b2bId : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _b2b = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Portal-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.portalId : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _portalId = newValue!;
                              },
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Portal Password',
                                hintText: _isEditing
                                    ? widget.merchant!.portalPassword
                                    : "",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Must be at least 2 characters';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _portalPassword = newValue!;
                              },
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: _createMerchant,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: logoColors[1],
                                ),
                                child: const Text(
                                  'Onboard',
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
