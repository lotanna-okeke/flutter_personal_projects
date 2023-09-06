import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/edit_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItmes();
  }

  void _loadItmes() async {
    final url = Uri.parse(
        'https://flutter-prep-9d2e5-default-rtdb.firebaseio.com/shopping-list.json');

    try {
      final response = await http.get(url);
      setState(() {
        if (response.statusCode >= 400) {
          _error = "Failed to fetch data. Please try again later.";
        }
      });

      print(response.body);

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      // print(listData.values.length.toString());

      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (element) => element.value.title == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _error = "Something went wrong. Please try again later.";
      });
    }
  }

  void _removeItem(GroceryItem item) async {
    final _itemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final urlDelete = Uri.https(
        'flutter-prep-9d2e5-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(urlDelete);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "Item Deleted",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "Invalid URL",
            textAlign: TextAlign.center,
          ),
        ),
      );
      setState(() {
        _groceryItems.insert(_itemIndex, item);
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => EditItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
    // _loadItmes();
  }

  void _editItem(GroceryItem item) async {
    final itemIndex = _groceryItems.indexOf(item);
    final edittedItem = await Navigator.push<GroceryItem>(
        context,
        MaterialPageRoute(
          builder: (context) => EditItem(editItem: item),
        ));

    if (edittedItem == null) {
      return;
    }
    setState(() {
      _groceryItems.replaceRange(itemIndex, itemIndex + 1, [edittedItem]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You got no items yet',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'Add an item with the add icon by the top right',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          ),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _groceryItems[index].name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 20),
                Text(
                  _groceryItems[index].quantity.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: IconButton(
                onPressed: () {
                  _editItem(_groceryItems[index]);
                },
                icon: const Icon(Icons.edit)),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      body: content,
    );
  }
}


//Another method, but it doesnt auto update
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shopping_list/data/categories.dart';

// import 'package:shopping_list/models/grocery_item.dart';
// import 'package:shopping_list/widgets/new_item.dart';

// class GroceryList extends StatefulWidget {
//   const GroceryList({super.key});

//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }

// class _GroceryListState extends State<GroceryList> {
//   List<GroceryItem> _groceryItems = [];
//   late Future<List<GroceryItem>> _loadedItems;
//   String? _error;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadedItems = _loadItmes();
//   }

//   Future<List<GroceryItem>> _loadItmes() async {
//     final url = Uri.https(
//         'flutter-prep-9d2e5-default-rtdb.firebaseio.com', 'shopping-list.json');

//     final response = await http.get(url);
//     if (response.statusCode >= 400) {
//       throw Exception('Failed to fetch grocery items. Please try again later.');
//     }

//     if (response.body == 'null') {
//       return [];
//     }

//     final Map<String, dynamic> listData = json.decode(response.body);
//     // print(listData.values.length.toString());

//     final List<GroceryItem> loadedItems = [];

//     for (final item in listData.entries) {
//       final category = categories.entries
//           .firstWhere(
//               (element) => element.value.title == item.value['category'])
//           .value;
//       loadedItems.add(
//         GroceryItem(
//           id: item.key,
//           name: item.value['name'],
//           quantity: item.value['quantity'],
//           category: category,
//         ),
//       );
//     }
//     return loadedItems;
//   }

//   void _addItem() async {
//     final newItem = await Navigator.push<GroceryItem>(
//       context,
//       MaterialPageRoute(
//         builder: (ctx) => NewItem(),
//       ),
//     );
//     if (newItem == null) {
//       return;
//     }
//     setState(() {
//       _groceryItems.add(newItem);
//     });
//     // _loadItmes();
//   }

//   void _removeItem(GroceryItem item) async {
//     // var passedItem = item;
//     var _isDeleted = true;

//     final _itemIndex = _groceryItems.indexOf(item);
//     setState(() {
//       _groceryItems.remove(item);
//     });
//     final urlDelete = Uri.https(
//         'flutter-prep-9d2e5-default-rtdb.firebaseio.com',
//         'shopping-list/${item.id}.json');
//     final response = await http.delete(urlDelete);

//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         duration: Duration(seconds: 3),
//         content: Text(
//           "Item Deleted",
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );

//     if (response.statusCode >= 400) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           duration: Duration(seconds: 3),
//           content: Text(
//             "Invalid URL",
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//       setState(() {
//         _groceryItems.insert(_itemIndex, item);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Groceries'),
//         actions: [
//           IconButton(
//             onPressed: _addItem,
//             icon: const Icon(Icons.add),
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _loadedItems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 snapshot.error.toString(),
//               ),
//             );
//           }

//           if (snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'You got no items yet',
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontSize: 24,
//                         ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     'Add an item with the add icon by the top right',
//                     style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                           fontSize: 18,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (ctx, index) => Dismissible(
//               key: ValueKey(snapshot.data![index].id),
//               background: Container(
//                 color: Theme.of(context).colorScheme.error.withOpacity(0.5),
//               ),
//               onDismissed: (direction) {
//                 _removeItem(snapshot.data![index]);
//               },
//               child: ListTile(
//                 title: Text(snapshot.data![index].name),
//                 leading: Container(
//                   width: 24,
//                   height: 24,
//                   color: snapshot.data![index].category.color,
//                 ),
//                 trailing: Text(snapshot.data![index].quantity.toString()),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
