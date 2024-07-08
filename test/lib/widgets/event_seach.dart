import 'package:flutter/material.dart';
import 'package:test/data/functions.dart';
import 'package:test/models/event.dart';
import 'package:test/widgets/event_card.dart';
import 'package:test/widgets/noEntry.dart';

class EventSearchDelegate extends SearchDelegate {
  final List<Event> diaryEntries;
  final Function() onEdit;
  final Function() onDelete;

  EventSearchDelegate(this.diaryEntries, this.onEdit, this.onDelete);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = diaryEntries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          entry.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    print(results);
    return (results.isEmpty)
        ? const NoEntry(icons: Icons.event_busy, text: "Event Doesn't Exist")
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              bool showDate = index == 0 ||
                  results[index].expiryDate != results[index - 1].expiryDate;
              // String emoji = determineEmoji(
              //     results[index].expiryDate.toString(),
              //     results[index].category);
              return EventCard(
                event: results[index],
                showDate: showDate,
                onEdit: onEdit,
                onDelete: onDelete,
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = diaryEntries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          entry.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return suggestions.isEmpty
        ? const NoEntry(icons: Icons.event_busy, text: "Event Doesn't Exist")
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              bool showDate = index == 0 ||
                  suggestions[index].expiryDate !=
                      suggestions[index - 1].expiryDate;
              // String emoji = determineEmoji(
              //     suggestions[index].expiryDate.toString(),
              //     suggestions[index].category);
              return EventCard(
                event: suggestions[index],
                showDate: showDate,
                onEdit: onEdit,
                onDelete: onDelete,
              );
            },
          );
  }
}
