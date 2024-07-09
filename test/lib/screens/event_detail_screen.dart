import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:test/data/functions.dart';
import 'package:test/models/event.dart';
import 'package:test/screens/edit_event.dart'; // Import the EditEventPage
import 'package:http/http.dart' as http;

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final Function() onEdit;
  final Function() onDelete;

  EventDetailScreen({
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  List<String> oneTimeReminders = [
    'A day before',
    'A week before',
    'A month before',
    'A year before'
  ];
  List<String> repeatReminders = [
    'Every Day',
    'Every Week',
    'Every Month',
    'Every Year'
  ];
  Map<String, bool> reminderSelections = {};

  @override
  void initState() {
    super.initState();
    initializeReminderSelections();
    print(widget.event.id);
  }

  void initializeReminderSelections() {
    for (var reminder in oneTimeReminders) {
      reminderSelections[reminder] =
          widget.event.reminderTypes.contains(getReminderLabel(reminder));
    }
    for (var reminder in repeatReminders) {
      reminderSelections[reminder] =
          widget.event.reminderTypes.contains(getReminderLabel(reminder));
    }
  }

  void _deleteEvent() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print(widget.event.id);
      final response = await http.delete(
          Uri.parse("http://10.0.2.2:8080/api/events/${widget.event.id}"));
      print(response.statusCode);
      if (response.statusCode == 200) {
        widget.onDelete();
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Deleted'),
            content: Text(response.body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> collectSelectedReminders() {
    List<String> selectedReminders = [];
    reminderSelections.forEach((reminder, selected) {
      if (selected) {
        selectedReminders.add(getReminderLabel(reminder));
      }
    });
    return selectedReminders;
  }

  Future<void> _saveEvent() async {
    final List<String> selectedReminders = collectSelectedReminders();

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
          "title": widget.event.title,
          "content": widget.event.content,
          "issueDate": widget.event.issueDate != null
              ? DateFormat('yyyy-MM-dd').format(widget.event.issueDate!)
              : null,
          "expiryDate":
              DateFormat('yyyy-MM-dd').format(widget.event.expiryDate!),
          "renewalDays": widget.event.renewalDays,
          "reminders": {
            "recurring": widget.event.recurring,
            "types": selectedReminders
          },
        }),
      );

      if (response.statusCode == 200) {
        widget.onEdit(); // Call the onEdit callback to refresh the home screen
        Navigator.pop(context);

        // Handle successful response
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Updated'),
            content: Text("Event updated successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editEvent() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      builder: (context) => EditEventPage(event: widget.event),
    );

    if (result == true) {
      widget.onEdit(); // Call the onEdit callback to refresh the home screen
      Navigator.pop(context);

      // Handle successful response
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Editted'),
          content: Text("Event editted successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
    }
  }

  String getReminderLabel(String reminder) {
    switch (reminder) {
      case 'A day before':
        return 'DAY_BEFORE';
      case 'A week before':
        return 'WEEK_BEFORE';
      case 'A month before':
        return 'MONTH_BEFORE';
      case 'A year before':
        return 'YEAR_BEFORE';
      case 'Every Day':
        return 'DAILY';
      case 'Every Week':
        return 'WEEKLY';
      case 'Every Month':
        return 'MONTHLY';
      case 'Every Year':
        return 'YEARLY';
      default:
        return '';
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM dd, yyyy')
        .format(date); // Format date as "June 13, 2024"
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentReminders =
        widget.event.recurring ? repeatReminders : oneTimeReminders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_isLoading) ...[
            const CircularProgressIndicator()
          ] else ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editEvent,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteEvent,
            ),
          ]
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    determineEmoji(widget.event.expiryDate.toString(),
                        widget.event.category),
                    style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                Text(widget.event.category,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: 40),
            if (!widget.event.recurring) ...[
              Row(
                children: [
                  Text('Gotten: ', style: TextStyle(fontSize: 14)),
                  Text(formatDate(widget.event.issueDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Expires: ', style: TextStyle(fontSize: 14)),
                  Text(formatDate(widget.event.expiryDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Text('Date: ', style: TextStyle(fontSize: 14)),
                  Text(formatDate(widget.event.expiryDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
            SizedBox(height: 10),
            Row(
              children: [
                Text('Description: ', style: TextStyle(fontSize: 14)),
                Flexible(
                    child: Text(
                  (widget.event.content),
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text('Remind Me:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Repeat'),
                  selected: widget.event.recurring,
                  onSelected: (selected) {},
                ),
                SizedBox(width: 16),
                ChoiceChip(
                  label: Text('One-Time'),
                  selected: !widget.event.recurring,
                  onSelected: (selected) {},
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: currentReminders.map((reminder) {
                return Row(
                  children: [
                    Checkbox(
                      value: reminderSelections[reminder] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          reminderSelections[reminder] = value ?? false;
                        });
                      },
                    ),
                    Text(reminder, style: TextStyle(fontSize: 16)),
                  ],
                );
              }).toList(),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_alert, size: 24),
                label: Text('Save', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  _saveEvent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
