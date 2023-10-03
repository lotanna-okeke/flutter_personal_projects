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
  var _enteredEmail = "";
  var _enteredPassword = "";
  var error = "";
  var _isloading = false;
  bool _obscureText = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });

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
          _isloading = false;
        });
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          error = "";
        });
        return;
      }
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
                        _isloading
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
                child: Text(
                  'Ensure you have the right username and password\nAlso feel free to check in with our Admins to ensure you\'ve not been disabled',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
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
