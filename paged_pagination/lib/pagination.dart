import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageBasedPaginationExample extends StatefulWidget {
  @override
  _PageBasedPaginationExampleState createState() =>
      _PageBasedPaginationExampleState();
}

class _PageBasedPaginationExampleState
    extends State<PageBasedPaginationExample> {
  int _currentPage = 1;
  int _totalPages = 4; // Replace with the actual total number of pages.
  int _pageSize = 25;
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    print('init');
    _loadData(_currentPage);
  }

  Future<void> _loadData(int page) async {
    // print(_currentPage)
    // Simulate loading data from an API or another source for the specified page.
    await Future.delayed(Duration(seconds: 2));
    print('load');
    // Generate data for the current page.
    final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$_pageSize&_page=$page');
    final response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final List newItems = jsonDecode(response.body);

      setState(() {
        items = newItems.map((item) {
          final number = item['id'];
          return 'Page $page Item $number';
        }).toList();
      });
    }
    // final newData =
    //     List.generate(_pageSize, (index) => 'Page $page - Item ${index + 1}');
  }

  void _loadNextPage() {
    print('next');
    if (_currentPage < _totalPages) {
      _currentPage++;
      _loadData(_currentPage);
    }
  }

  void _loadPreviousPage() {
    print('prev');
    if (_currentPage > 1) {
      _currentPage--;
      _loadData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page-Based Pagination Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _loadPreviousPage,
                  child: Text('Previous Page'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _loadNextPage,
                  child: Text('Next Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
