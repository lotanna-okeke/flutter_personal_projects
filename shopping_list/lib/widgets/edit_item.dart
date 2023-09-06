import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class EditItem extends StatefulWidget {
  const EditItem({
    super.key,
    this.editItem,
  });

  final GroceryItem? editItem;

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaved = false;
  bool _isNew = false;
  GroceryItem? item;
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables];
  // void _operation;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSaved = true;
      });

      final url = Uri.https('flutter-prep-9d2e5-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.post(
        url,
        headers: {'Contain-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory!.title,
          },
        ),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
        GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory!,
        ),
      );
    }
  }

  void _edittedItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSaved = true;
      });

      if (_enteredName == item!.name &&
          _enteredQuantity == item!.quantity &&
          _selectedCategory == item!.category) {
        setState(() {
          _isSaved = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Nothing was editted'),
            action: SnackBarAction(
              label: 'Continue',
              onPressed: () {
                return;
              },
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        final url = Uri.https('flutter-prep-9d2e5-default-rtdb.firebaseio.com',
            'shopping-list/${item!.id}.json');
        final response = await http.patch(
          url,
          // headers: {'Contain-Type': 'application/json'},
          body: json.encode(
            {
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory!.title,
            },
          ),
        );

        final Map<String, dynamic> resData = jsonDecode(response.body);

        if (!context.mounted) {
          return;
        }

        Navigator.of(context).pop(
          GroceryItem(
            id: resData['name'],
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory!,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editItem == null) {
      _isNew = true;
      // _operation = _saveItem();
    } else {
      item = widget.editItem;
      _enteredName = item!.name;
      _enteredQuantity = item!.quantity;
      _selectedCategory = item!.category;
      // _operation = _edittedItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isNew ? 'Save Item' : "Edit Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                initialValue: _enteredName,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 2 and 50';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                      ),
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 8),
                                Text(category.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaved
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSaved
                        ? null
                        : _isNew
                            ? _saveItem
                            : _edittedItem,
                    child: _isSaved
                        ? const SizedBox(
                            width: 16,
                            height: 18,
                            child: CircularProgressIndicator(),
                          )
                        : Text(_isNew ? 'Save Item' : "Edit Item"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
