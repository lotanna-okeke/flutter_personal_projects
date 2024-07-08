import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/data/functions.dart';
import 'package:test/screens/event_detail_screen.dart';
import 'package:test/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool showDate;
  final Function() onEdit;
  final Function() onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.showDate,
    required this.onEdit,
    required this.onDelete,
  });

  String _getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy')
        .format(date); // Formats date to 'd MMM yyyy'
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _getFormattedDate(event.expiryDate);
    final dateParts = formattedDate.split(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                event: event,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDate) ...[
              Column(
                children: [
                  Text(
                    dateParts[0], // Day
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateParts[1], // Abbreviated month
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    dateParts[2], // Year
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ] else ...[
              const SizedBox(width: 44),
            ],
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            determineEmoji(
                                event.expiryDate.toString(), event.category),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        height: 1,
                      ),
                      const SizedBox(height: 5),
                      Text(event.content),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
