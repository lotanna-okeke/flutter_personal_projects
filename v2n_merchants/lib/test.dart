import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({
    super.key,
  });

  @override
  _CheckInternetConnectionState createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });

    // Navigate to NoInternetPage if there is no internet connection.
    if (_connectivityResult == ConnectivityResult.none) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => NoInternetPage(),
      //   ),
      // );
      setState(() {
        content = Center(
          child: Text('wow'),
        );
      });
    }
  }

  Widget content = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Internet Connection'),
      ),
      body: content,
    );
  }
}
