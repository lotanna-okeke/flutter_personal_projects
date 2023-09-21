import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  void login() async {
    final apiUrl = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-merchants?page=1&perPage=100');
    const bearerToken =
        "ILT8yreYHoUruGwMts0OzAR88daUUCbBoR7XPa5hPUxkVqPc4zYKCfP8Yp0FvYlsr2yETajXYJcAVwVTO0mWuRbDUAYlw7xKRv7W2Q02111ffBMv5HQJRBNdZvmmYn9XjGkNPKr9wiMM0errEcKwKd3ks3o9Ism9kLPQ76zxTHWk1pAv0H9lsa2ySBdrtW5AEX5eWOSy";

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };
    print(headers);

    try {
      var response = await http.get(
        apiUrl,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Request was successful, print the response body
        print('Response data: ${response.body}');
      } else {
        // Request failed, handle errors here
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the request
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
