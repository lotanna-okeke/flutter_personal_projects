import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:referral_app/enums/state.dart';
import 'package:referral_app/provider/auth_provider.dart';
import 'package:referral_app/screens/authentication/ref_page.dart';

import '../../utils/message.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Register your account",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(30.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    CustomTextField(
                                      _emailController,
                                      hint: 'Email',
                                      password: false,
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      _passwordController,
                                      hint: 'Password',
                                      obscure: true,
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print(_emailController.text);
                                    print(_passwordController.text);
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      showMessage(
                                          context, "All Field requires");
                                    } else {
                                      await model.registerUser(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim());
                                      if (model.state == ViewState.Success) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    RefCodePage()),
                                            (route) => false);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showMessage(
                                            context, model.message.trim());
                                      }
                                    }
                                    //Validate User Inputs
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Regsiter",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => LoginPage()));
                                    //Navigate to Register Page
                                  },
                                  child: Text(
                                    "Already have account?",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
