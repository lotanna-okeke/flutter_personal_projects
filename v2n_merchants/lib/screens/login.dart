import 'package:flutter/material.dart';
import 'package:v2n_merchants/data.dart';
import 'package:v2n_merchants/screens/admin/adminHome.dart';
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

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_enteredEmail == 'admin@v2n.com' && _enteredPassword == '#1Aaaa') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeScreen(),
          ),
        );
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
                            final validEmail =
                                RegExp("^[a-zA-Z0-9+_.-]+@[a-z]+.[a-z]");
                            if (!(value!.contains(validEmail))) {
                              return "Invalid email address";
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
