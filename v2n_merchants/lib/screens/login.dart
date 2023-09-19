import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/admin/screens/adminHome.dart';
import 'package:v2n_merchants/widgets/term_of_use.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassword = "";

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse(
          'http://132.226.206.68/vaswrapper/jsdev/clientmanager/login');
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "username": _enteredEmail,
            "password": _enteredPassword,
          },
        ),
      );

      if (response.statusCode == 200) {
        final output = jsonDecode(response.body);
        final token = output['token'];
        print(token);
        final url2 = Uri.parse(
            'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-merchants?page=1&perPage=10');
        Map<String, String> headers = {
          "Authorization": 'Bearer $token',
        };
        final response2 = await http.get(
          url2,
          headers: headers,
        );

        print(response2.statusCode);

        if (response2.statusCode == 200) {
          final merchants = jsonDecode(response2.body);
          print(merchants);
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AdminHomeScreen(
        //       token: token,
        //     ),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not Admin'),
          ),
        );
        return;
      }
    }
  }

  void login() async {
    final apiUrl = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-merchants');
    String bearerToken =
        "J0oQRMjI8lP6dmP6GNRjDQBg9ezbLcpWClFAgaGjILOuVcam9xMR5gVLVza3FuWUr6ySZlkvdu4M79OuppY5KqAaxgxrGO44BuSORcVqUZEWvTfYmlHd11WnyxjZwzy2w1CgsppbQ4Z5ryfx2Clg8ex8Sw2H4hgottxZQy7mjbXq1u46fXFXKw6MSzJYoDPWaRGjQ0Lu";

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

// Make an HTTP GET request with headers
    var response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      // Request was successful, handle the response data here
      print('Response data: ${response.body}');
    } else {
      // Request failed, handle errors here
      print('Request failed with status code: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  void _showTerms() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => const TermOfUse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 80,
                child: Image.asset('assets\\images\\Logo.png'),
              ),
              Card(
                // color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'john123@gmail.com',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7))),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null) {
                              return 'Email cannot be empty';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          validator: (value) {
                            if (value == null) {
                              return 'Password cannot be empty';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: _showTerms,
                            child: Text(
                              'Terms of Use and Privacy Policy',
                              style: TextStyle(
                                color: logoColors[1],
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: logoColors[1],
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 30,
                  right: 30,
                  // bottom: 20,
                ),
                child: const Text(
                  'By clicking on \"Login\" you agree in our \nTerms of Use and Privacy Policy',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
