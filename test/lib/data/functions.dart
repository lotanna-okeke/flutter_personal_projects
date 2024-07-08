import 'package:intl/intl.dart';
import 'package:test/models/event.dart';

import 'data.dart';

String determineEmoji(String eventDate, String category) {
  if (category == "Birthday") {
    return '🎂';
  }
  if (category == "Normal") {
    return '🔔';
  }
  try {
    final eventDateTrimmed = eventDate.trim();
    final eventDateParsed = DateFormat('yyyy-MM-dd').parse(eventDateTrimmed);
    final now = DateTime.now();
    final difference = eventDateParsed.difference(now).inDays;

    if (difference < 0) {
      return '❌';
    } else if (difference <= 7) {
      return '😱'; // Very urgent
    } else if (difference <= 200) {
      return '🙁'; // Urgent
    } else {
      return '😁'; // Not urgent
    }
  } catch (e) {
    // In case of an error, return a default emoji
    return '🤔';
  }
}

String determineCategory(String emoji) {
  if (emoji == "🎂") {
    return "Birthday";
  } else if (emoji == "🔔") {
    return "Event";
  } else {
    return "Certificate";
  }
}

void yesterday() {
  final now = DateTime.now();
  final yesterday = now.subtract(Duration(days: 1));
  print(yesterday);
}

void tomorrow() {
  final now = DateTime.now();
  final tomorrow = now.add(Duration(days: 1));
  print(tomorrow);
}

void monthBefore() {
  final now = DateTime.now();
  final lastMonth = DateTime(now.year, now.month - 1, now.day);
  print(lastMonth);
}

void weekBefore() {
  final now = DateTime.now();
  final lastWeek = now.subtract(Duration(days: 7));
  print(lastWeek);
}

void listOfTheNextTenYears() {
  final now = DateTime.now();
  for (int i = 0; i < 10; i++) {
    final nextYear = DateTime(now.year + i + 1, now.month, now.day);
    print(nextYear);
  }
}

List<DateTime> calculateNotificationDates(Event event) {
  List<DateTime> notificationDates = [];
  DateTime targetDate = event.expiryDate ?? event.issueDate ?? DateTime.now();

  for (String type in event.reminderTypes) {
    switch (type) {
      case 'DAY_BEFORE':
        notificationDates.add(targetDate.subtract(Duration(days: 1)));
        break;
      case 'WEEK_BEFORE':
        notificationDates.add(targetDate.subtract(Duration(days: 7)));
        break;
      case 'MONTH_BEFORE':
        notificationDates.add(targetDate.subtract(Duration(days: 30)));
        break;
      case 'YEAR_BEFORE':
        notificationDates.add(targetDate.subtract(Duration(days: 365)));
        break;
      case 'WEEKLY':
        if (event.recurring) {
          for (int i = 1; i <= 52; i++) {
            notificationDates.add(targetDate.add(Duration(days: 7 * i)));
          }
        }
        break;
      case 'YEARLY':
        if (event.recurring) {
          for (int i = 1; i <= 10; i++) {
            notificationDates.add(targetDate.add(Duration(days: 365 * i)));
          }
        }
        break;
    }
  }

  return notificationDates;
}

