import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:referral_app/screens/home_page.dart';

import '../../enums/state.dart';
import '../../provider/ref_provider.dart';
import '../../utils/message.dart';
import 'login.dart';

class RefCodePage extends StatefulWidget {
  @override
  _RefCodePageState createState() => _RefCodePageState();
}

class _RefCodePageState extends State<RefCodePage> {
  final TextEditingController _refController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RefProvider>(builder: (context, model, child) {
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
                        "Enter Referral Code",
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
                                      _refController,
                                      hint: 'Referral Code',
                                      password: false,
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_refController.text.isEmpty) {
                                      showMessage(
                                          context, "All Field requires");
                                    } else {
                                      await model.setReferral(
                                          _refController.text.trim());
                                      if (model.state == ViewState.Success) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    const HomePage()),
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
                                    child: const Text(
                                      "Continue",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                        (route) => false);
                                    //Navigate to Register Page
                                  },
                                  child: Text(
                                    "No Referral? Continue instead.",
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
