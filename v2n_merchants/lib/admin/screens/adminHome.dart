import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:v2n_merchants/funtions.dart';
import 'package:v2n_merchants/models/merchant.dart';
import 'package:v2n_merchants/admin/screens/new_merchant.dart';
import 'package:v2n_merchants/admin/widgets/admin_drawer.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({
    super.key,
    this.token,
  });

  final String? token;

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  bool _isConnected = true;

  List<FetchMerchants> _merchants = [];
  //to contol the search input
  final _seachController = TextEditingController();

  // to check whn data is loading
  var _isLoading = true;

  // to control the buttons at the bottom
  bool _isFirstPage = false;
  bool _isLastPage = false;
  bool _noPagination = false;

  // bool _statusNotChanged = true;

  String? _error;
  int _currentPage = 1;
  double _totalPages = 1;
  int pageSize = 10;

  // To search
  String _searchText = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // _loadItmes();
    _loadData(_currentPage);
    setButtons(_currentPage);
  }

  void checkConnection() async {
    Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_isLoading) {
        // If _isLoading is still true after 30 seconds, perform an action.
        print('not connected');
        setState(() {
          _isConnected = false;
        });

        // Stop the timer if the action should only be performed once.
        timer.cancel();
      } else {
        // If _isLoading becomes false before 30 seconds, cancel the timer.
        print('connected');

        setState(() {
          _isConnected = true;
          _isLoading = false;
        });

        timer.cancel();
        return;
      }
    });
    // await Future.delayed(const Duration(seconds: 20));
    // setState(() {
    //   _isLoading = false;
    //   _isConnected = false;
    // });
  }

  void setButtons(int page) {
    print(widget.token);
    if (page == (_totalPages.toInt()) + 1) {
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

  void _loadData(int page) async {
    setState(() {
      _isLoading = true;
      _noPagination = false;
    });
    checkConnection();

    await Future.delayed(const Duration(seconds: 1));

    //load the data from the API
    _loadMerchants(page);
  }

  void _loadMerchants(int page) async {
    final url2 = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/fetch-merchants?page=$page&perPage=$pageSize');
    Map<String, String> headers = {
      "Authorization": 'Bearer ${widget.token}',
    };
    final response2 = await http.get(
      url2,
      headers: headers,
    );

    print(response2.statusCode);

    if (response2.statusCode == 200) {
      final body = jsonDecode(response2.body);
      final merchants = body['message']['merchants'];
      setState(() {
        _totalPages = body['totalCount'] / pageSize;
        if ((_totalPages.toInt()) == 0) {
          _noPagination = true;
        }
      });
      print(merchants);

      final List<FetchMerchants> loadedMerchants = [];

      for (final merchant in merchants) {
        print(merchant);
        loadedMerchants.add(
          FetchMerchants(
            id: merchant['id'],
            name: merchant['name'],
            username: merchant['username'],
            role: merchant['role'],
            parentId: merchant['parentID'],
            airtimeId: merchant['airtimeID'],
            dataId: merchant['dataID'],
            b2bId: merchant['b2bID'],
            portalId: merchant['portalID'],
            status: merchant['status'],
            isActive: (merchant['status'] == "ACTIVE"),
          ),
        );
      }
      setState(() {
        _merchants = loadedMerchants;
        _isLoading = false;
        // _isLoadingPage = false;
      });
    } else {
      setState(() {
        _error = "Failed to fetch data. Please logout and login again.";
      });
    }
  }

  void _loadNextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      _loadData(_currentPage);
      setButtons(_currentPage);
    }
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      _loadData(_currentPage);
      setButtons(_currentPage);
    }
  }

  void _searchMerchant() async {
    if (_seachController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    checkConnection();
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/find-merchant');
    Map<String, String> headers = {
      "Authorization": 'Bearer ${widget.token}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(
        {
          "username": _seachController.text.trim(),
        },
      ),
    );
    final body = jsonDecode(response.body);
    final message = body['message'];
    if (response.statusCode == 200) {
      final airtime = message['airtimeID'];
      final merchant = FetchMerchants(
        id: message['id'],
        name: message['name'],
        username: message['username'],
        role: message['role'],
        parentId: message['parentID'],
        airtimeId: airtime,
        dataId: message['dataID'],
        b2bId: message['b2bID'],
        portalId: message['portalID'],
        status: message['status'],
        isActive: (message['status'] == "ACTIVE"),
      );

      setState(() {
        _merchants = [merchant];
        _searchText = "Merchant found";
      });
    } else {
      setState(() {
        _searchText = "Merchant not found";
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _searchText = "";
      });
      _loadData(_currentPage);
      setButtons(_currentPage);
    }
    setState(() {
      _isLoading = false;
    });
    _seachController.text = "";
  }

  void _addMerchant() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMerchant(
          token: widget.token!,
        ),
      ),
    );
    _searchText = "";
    _loadData(_currentPage);
    setButtons(_currentPage);
  }

  void editMerchant(FetchMerchants merchant) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMerchant(
          token: widget.token!,
          merchant: merchant,
        ),
      ),
    );
    _searchText = "";
    _loadData(_currentPage);
    setButtons(_currentPage);
  }

  void suspendMerchant(FetchMerchants merchant) async {
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/suspend-merchant');
    final response = await http.put(
      url,
      headers: {
        "Authorization": 'Bearer ${widget.token}',
      },
      body: jsonEncode(
        {
          "username": merchant.username,
        },
      ),
    );
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            '${response.body}\nTry to logout and login again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void activeMerchant(FetchMerchants merchant) async {
    final url = Uri.parse(
        'http://132.226.206.68/vaswrapper/jsdev/clientmanager/activate-merchant');
    final response = await http.put(
      url,
      headers: {
        "Authorization": 'Bearer ${widget.token}',
      },
      body: jsonEncode(
        {
          "username": merchant.username,
        },
      ),
    );
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            '${response.body}\nTry to logout and login again',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void changeActiveStatus(FetchMerchants merchant) async {
    if (merchant.isActive!) {
      suspendMerchant(merchant);
    } else {
      activeMerchant(merchant);
    }
  }

  Future _refresh() async {
    setState(() {
      _isLoading = true;
      _isConnected = true;
    });
    checkConnection();
    setState(() {
      _merchants = [];
      _currentPage = 1;
      _totalPages = 1;

      // To search
      _searchText = "";
      // _isConnected = false;
    });
    // initState();
    _loadData(_currentPage);
    setButtons(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthPercentage = screenWidth / 100;
    final heightPercentage = screenHeight / 100;

    final fontSize =
        screenWidth > 600 ? widthPercentage * 5 : widthPercentage * 4.3;
    final buttonFontSize =
        screenWidth > 600 ? widthPercentage * 4.2 : widthPercentage * 3.9;
    final cardPadding = EdgeInsets.symmetric(
      horizontal: widthPercentage * 3,
      vertical: heightPercentage * 1.5,
    );

    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You got no items yet',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
          ),
          Container(
            height: heightPercentage * 2.5,
          ),
          Text(
            'Add an item with the add icon by the bottom right',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: fontSize - 6,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );

    Widget controlButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _loadPreviousPage,
          child: Text(
            'Previous',
            style: TextStyle(fontSize: buttonFontSize),
          ),
        ),
        Container(
          width: widthPercentage * 4,
        ),
        ElevatedButton(
          onPressed: _loadNextPage,
          child: Text(
            'Next',
            style: TextStyle(fontSize: buttonFontSize),
          ),
        ),
      ],
    );

    if (_isLoading) {
      content = Center(child: CircularProgressIndicator());
    }

    if (!_isConnected) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: heightPercentage * 10,
            ),
            Text(
              'Please connect to the internet',
              style: TextStyle(color: Colors.black, fontSize: fontSize),
            ),
            TextButton(
              onPressed: () {
                _refresh();
              },
              child:
                  Text('Refresh', style: TextStyle(fontSize: buttonFontSize)),
            ),
          ],
        ),
      );
    }

    if (_noPagination) {
      controlButtons = Center();
    }

    if (_isFirstPage && !_noPagination) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadNextPage,
          child: Text('Next', style: TextStyle(fontSize: buttonFontSize)),
        ),
      );
    }

    if (_isLastPage && !_noPagination) {
      controlButtons = Center(
        child: ElevatedButton(
          onPressed: _loadPreviousPage,
          child: Text('Previous', style: TextStyle(fontSize: buttonFontSize)),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      );
    }

    if (_searchText == "Merchant not found") {
      content = Center(
        child: Text(
          _searchText,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      );
    }

    if (_merchants.isNotEmpty && !_isLoading) {
      content = Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: heightPercentage * 3, bottom: heightPercentage * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Card(
                  child: TextField(
                    controller: _seachController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: logoColors[1],
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: logoColors[1],
                        fontSize: fontSize - 4,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _searchMerchant,
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              child: ListView.builder(
                itemCount: _merchants.length,
                itemBuilder: (context, index) {
                  final merchant = _merchants[index];
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: cardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${merchant.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: fontSize,
                                        ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      editMerchant(merchant);
                                    },
                                    color: Colors.black,
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                  Container(
                                    width: widthPercentage * 4,
                                  ),
                                ],
                              ),
                              SizedBox(height: heightPercentage * 0.4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      merchant.username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                            fontSize: fontSize,
                                          ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      changeActiveStatus(merchant);
                                      setState(() {
                                        merchant.isActive = !merchant.isActive!;
                                      });
                                    },
                                    icon: Icon(
                                      (merchant.isActive!)
                                          ? Icons.thumb_up
                                          : Icons.block,
                                      color: Colors.black,
                                    ),
                                    label: Text(
                                      (merchant.isActive!)
                                          ? 'Active'
                                          : 'Disabled',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: (merchant.isActive!)
                                                ? Color.fromARGB(
                                                    255, 50, 205, 50)
                                                : Colors.red,
                                            fontSize: fontSize,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          (_searchText == "Merchant found")
              ? TextButton(
                  onPressed: () {
                    _refresh();
                  },
                  child: Text(
                    'Refresh',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(
                    top: heightPercentage * 0.6,
                    bottom: heightPercentage * 0.6,
                    left: widthPercentage * 0.6,
                    right: widthPercentage * 4,
                  ),
                  child: controlButtons,
                ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'VasAdmin',
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: logoColors[1]!.withOpacity(0.9),
      ),
      drawer: AdminDrawer(
        token: widget.token!,
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: _addMerchant,
        child: Icon(Icons.add, size: fontSize),
      ),
    );
  }
}
