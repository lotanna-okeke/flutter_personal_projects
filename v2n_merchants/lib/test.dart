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
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-merchants.json');
    const bearerToken =
        "OyxIhAYBVUKcb5k1Gsg5L9oNAb33OsRHcbiNDcdgZmpKl5NI2GbrDb7G4xNb9EQMoEiuYnuEGdnrCGETVF7RGmmOJv3MuEl22rmXPvOpE8xUpNQ97Jgjqgm7pb6f9AiImBd9GXH6cPDbS5bTqIf7xRIK8s5EcEp9rohCFcVAZSR1bTrqiFg9g3Wa3mli54zbu3NAkvZB";

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    print(headers);

    try {
      var response = await http.get(
        apiUrl,
        headers: headers,
      );

      print(response);

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
