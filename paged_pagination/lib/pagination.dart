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
  bool _isFirstPage = false;
  bool _isLastPage = false;
  bool _isloading = false;
  int _totalPages = 4; // Replace with the actual total number of pages.
  int _pageSize = 25;
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    print('init');
    _loadData(_currentPage);
    setButtons(_currentPage);
  }

  void setButtons(int page) {
    // setState(() {
    //   _isFirstPage =
    // });
    if (page == _totalPages) {
      setState(() {
        _isLastPage = true;
      });
      return;
    }
    if (page == 1) {
      print(page);
      setState(() {
        _isFirstPage = true;
      });
      return;
    }
    setState(() {
      _isFirstPage = false;
      _isLastPage = false;
    });
  }

  Future<void> _loadData(int page) async {
    setState(() {
      _isloading = true;
    });

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
        _isloading = false;
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
      setButtons(_currentPage);
    }
  }

  void _loadPreviousPage() {
    print('prev');
    if (_currentPage > 1) {
      _currentPage--;
      _loadData(_currentPage);
      setButtons(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    Widget controlButtons = Row(
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
    );

    if (_isFirstPage) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadNextPage,
          child: Text('Next Page'),
        ),
      );
    }

    if (_isLastPage) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadPreviousPage,
          child: Text('Previous Page'),
        ),
      );
    }

    if (!_isloading) {
      content = Column(
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
            child: controlButtons,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Page-Based Pagination Example'),
      ),
      body: content,
    );
  }
}
