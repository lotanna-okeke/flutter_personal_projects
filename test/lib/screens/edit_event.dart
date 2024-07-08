import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/models/event.dart';
import 'package:http/http.dart' as http;

class EditEventPage extends StatefulWidget {
  final Event event;

  EditEventPage({required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _contentController = TextEditingController(text: widget.event.content);
    print(widget.event.recurring);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _editEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8080/api/events/${widget.event.id}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "uid": widget.event.uid,
            "category": widget.event.category,
            "title": _titleController.text,
            "content": _contentController.text,
            "issueDate": widget.event.issueDate != null
                ? DateFormat('yyyy-MM-dd').format(widget.event.issueDate!)
                : null,
            "expiryDate":
                DateFormat('yyyy-MM-dd').format(widget.event.expiryDate!),
            "renewalDays": widget.event.renewalDays,
            "reminders": {
              "recurring": widget.event.recurring,
              "types": widget.event.reminderTypes
            },
          }),
        );

        print(response.statusCode);

        if (response.statusCode == 200) {
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update event')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(labelText: 'Content'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter content';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _editEvent,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
