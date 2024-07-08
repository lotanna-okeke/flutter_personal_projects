import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:test/data/functions.dart';
import 'package:test/models/event.dart';
import 'package:test/screens/add_event.dart';
import 'package:test/widgets/event_card.dart';
import 'package:test/widgets/noEntry.dart'; // Import your EventCard widget

class CalendarScreen extends StatefulWidget {
  final List<Event> diaryEntries;
  final Function() onEdit;
  final Function() onDelete;
  final Function() onAdd;

  const CalendarScreen({
    super.key,
    required this.diaryEntries,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  late List<Event> _filteredEntries;

  @override
  void initState() {
    super.initState();
    _filteredEntries = _filterEntriesForDay(_selectedDay);
  }

  List<Event> _filterEntriesForDay(DateTime day) {
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    return widget.diaryEntries.where((entry) {
      // Parse the expiryDate of the event
      DateTime? eventExpiryDate = entry.expiryDate;
      String formattedEventExpiryDate =
          DateFormat('yyyy-MM-dd').format(eventExpiryDate!);
      return formattedEventExpiryDate == formattedDay;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Calendar View',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 24),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _filteredEntries = _filterEntriesForDay(selectedDay);
              });
            },
          ),
          Expanded(
            child: _filteredEntries.isEmpty
                ? const NoEntry(
                    icons: Icons.alarm_off_outlined,
                    text: 'No reminder on this day')
                : ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      bool showDate = index == 0 ||
                          _filteredEntries[index].expiryDate !=
                              _filteredEntries[index - 1].expiryDate;
                      // String emoji = determineEmoji(
                      //   _filteredEntries[index].expiryDate.toString(),
                      //   _filteredEntries[index].category,
                      // );
                      return EventCard(
                        event: _filteredEntries[index],
                        showDate: showDate,
                        onEdit: widget.onEdit,
                        onDelete: widget.onDelete,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(
          Icons.add_alert,
          color: Colors.white,
        ),
        label: const Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
