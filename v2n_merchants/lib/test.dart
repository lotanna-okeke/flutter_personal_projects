import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            child: Text('data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                // return ListTile(
                //   title: Text('Item ${index}'),
                // );
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    'Item ${index}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
          // Container(
          //   color: Colors.blue,
          //   child: Text('data'),
          // )
        ],
      ),
    );
  }
}
