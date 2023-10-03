import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/models/merchant.dart';

class NewMerchant extends StatefulWidget {
  const NewMerchant({
    super.key,
    this.merchant,
    required this.token,
  });

  final FetchMerchants? merchant;
  final String token;

  @override
  State<NewMerchant> createState() => _NewMerchantState();
}

class _NewMerchantState extends State<NewMerchant> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSending = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  String? _name = '';
  String? _email = '';
  String? _password = '';
  String? _airtime = '';
  String? _data = '';
  String? _b2b = '';
  String? _portalId = '';
  String? _portalPassword = '';
  var _oldUserName = "";
  FetchMerchants? merchant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.merchant != null) {
      print(widget.merchant!.airtimeId);
      _isEditing = true;
      merchant = widget.merchant;
      _name = merchant!.name;
      _oldUserName = merchant!.username;
      _email = merchant!.username;
      _airtime = merchant!.airtimeId;
      _data = merchant!.dataId;
      _b2b = merchant!.b2bId;
      _portalId = merchant!.portalId;
    }
  }

  void _createMerchant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final url = Uri.parse(
          'http://132.226.206.68/vaswrapper/jsdev/clientmanager/create-merchant');
      Map<String, String> headers = {
        "Authorization": 'Bearer ${widget.token}',
      };
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "name": _name,
          "username": _email,
          "password": _password,
          "airtimeID": _airtime,
          "dataID": _data,
          "b2bID": _b2b,
          "transactionID": _portalId,
          "transactionPassword": _portalPassword,
        }),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Created'),
            content: const Text('Merchant created Successfully'),
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
    }
    setState(() {
      _isSending = false;
    });
  }

  void _editMerchant() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final url = Uri.parse(
          'http://132.226.206.68/vaswrapper/jsdev/clientmanager/update-merchant');
      Map<String, String> headers = {
        "Authorization": 'Bearer ${widget.token}',
      };
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(
          {
            "username": _oldUserName,
            "newName": _name,
            "newUsername": _email,
            "newPassword": _password,
            "airtimeID": _airtime,
            "dataID": _data,
            "b2bID": _b2b,
            "transactionID": _portalId,
            "transactionPassword": _portalPassword,
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Editted'),
            content: const Text('Merchant editted Successfully'),
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
                              initialValue: _email,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: _isEditing
                                    ? widget.merchant!.username
                                    : 'john123@gmail.com',
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
                                          _obscureText1 = !_obscureText1;
                                        });
                                      },
                                      icon: Icon(_obscureText1
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              obscureText: _obscureText1,
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
                            TextFormField(
                              initialValue: _airtime,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Airtime-ID',
                                hintText: _isEditing
                                    ? widget.merchant!.airtimeId
                                    : "",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                              ),
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
                              initialValue: _data,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Data-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.dataId : "",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                              ),
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
                              initialValue: _b2b,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'B2B-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.b2bId : "",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                              ),
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
                              initialValue: _portalId,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Portal-ID',
                                hintText:
                                    _isEditing ? widget.merchant!.portalId : "",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                ),
                              ),
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
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                      icon: Icon(_obscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              obscureText: _obscureText2,
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
                              child: _isSending
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _isEditing
                                          ? _editMerchant
                                          : _createMerchant,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: logoColors[1],
                                      ),
                                      child: Text(
                                        _isEditing ? "Edit" : 'Onboard',
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
