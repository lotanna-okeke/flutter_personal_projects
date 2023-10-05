import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/admin/screens/adminHome.dart';
import 'package:v2n_merchants/merchant/screens/tabs.dart';
import 'package:v2n_merchants/providers/merchant_handler.dart';
import 'package:v2n_merchants/widgets/term_of_use.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isConnected = true;

  var _enteredEmail = "";
  var _enteredPassword = "";
  var error = "";
  var _isLoading = false;
  bool _obscureText = true;

  void checkConnection() async {
    Timer.periodic(Duration(seconds: 15), (timer) {
      if (_isLoading) {
        // If _isLoading is still true after 30 seconds, perform an action.
        // print(
        //     'Performing action because _isLoading is still true after 30 seconds.');
        setState(() {
          _isConnected = false;
        });

        // Stop the timer if the action should only be performed once.
        timer.cancel();
      } else {
        // If _isLoading becomes false before 30 seconds, cancel the timer.
        // print(
        //     'Not Performing action because _isLoading is not still true after 30 seconds.');
        setState(() {
          _isConnected = true;
          _isLoading = false;
        });
        timer.cancel();
        return;
      }
    });
    // if (!_isConnected) {
    await Future.delayed(const Duration(seconds: 15));
    // }
    setState(() {
      _isLoading = false;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      checkConnection();

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
        final role = output['role'];

        if (role != "super-admin") {
          ref
              .read(MerchantHandlerProvider.notifier)
              .loadMerchants([_enteredEmail, token, role]);
          ref.read(FilterHandlerProvider.notifier).loadFilters(_enteredEmail);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TabsScreen(),
            ),
            (route) => false,
          );
          return;
        }

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeScreen(
              token: token,
            ),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          error = "Please ensure you have the right username and password";
          _isLoading = false;
        });
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          error = "";
        });
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showTerms() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => const TermOfUse(),
    );
  }

  void refresh() {
    setState(() {
      _isLoading = false;
      _isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'Ensure you have the right username and password\nAlso feel free to check in with our Admins to ensure you\'ve not been disabled',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    if (!_isConnected) {
      content = Column(
        children: [
          const Text(
            'Please connect to the internet',
            style: TextStyle(color: Colors.black),
          ),
          // const SizedBox(height: 10),
          TextButton(
            onPressed: refresh,
            child: const Text('Refresh'),
          ),
        ],
      );
    }

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
                            if (value == null || value.trim().isEmpty) {
                              return 'Must Contain a value';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
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
                            if (value == null || value.trim().length < 5) {
                              return 'Must Contain atleast 5 characters';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(height: 10),
                        (error.isEmpty)
                            ? const SizedBox(height: 0)
                            : Container(
                                alignment: Alignment.bottomLeft,
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
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _login,
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
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
