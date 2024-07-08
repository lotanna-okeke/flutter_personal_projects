import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test/models/event.dart';

final List<Map<String, dynamic>> diaryEntries = [
  {
    "id": 1,
    "uid": 123,
    "category": "Certificate",
    "title": "Driver License",
    "content": "I'm stressed af",
    "issueDate": "2024-06-13",
    "expiryDate": "2024-06-14",
    "reminders": {
      "recurring": false,
      "types": ["MONTH_BEFORE", "WEEK_BEFORE", "YEAR_BEFORE"]
    }
  },
  {
    "id": 2,
    "uid": 123,
    "category": "Certificate",
    "title": "International Passport Needed",
    "content": "Printf",
    "issueDate": "2019-06-14",
    "expiryDate": "2025-08-28",
    "reminders": {
      "recurring": false,
      "types": ["DAY_BEFORE", "WEEK_BEFORE", "YEAR_BEFORE"]
    }
  },
  {
    "id": 3,
    "uid": 123,
    "category": "Birthday",
    "title": "KK Birthday",
    "content": "Printf",
    "issueDate": null,
    "expiryDate": "2024-08-01",
    "reminders": {
      "recurring": true,
      "types": ["DAILY", "WEEKLY", "MONTHLY", "YEARLY"]
    }
  },
  {
    "id": 4,
    "uid": 123,
    "category": "Certificate",
    "title": "Visa",
    "content": "Printf",
    "issueDate": "2019-06-14",
    "expiryDate": "2024-08-01",
    "reminders": {
      "recurring": false,
      "types": ["DAY_BEFORE", "MONTH_BEFORE", "YEAR_BEFORE"]
    }
  },
  {
    "id": 5,
    "uid": 123,
    "category": "Normal",
    "title": "Printf",
    "content": "Printf",
    "issueDate": null,
    "expiryDate": "2025-05-30",
    "reminders": {"recurring": false, "types": []}
  },
  {
    "id": 6,
    "uid": 123,
    "category": "Certificate",
    "title": "Car particulars",
    "content":
        "You need to get your car particulars in order right now o sddsdsdcjknkfnjekrfb jh hrebrfbfh rffjhbfjerjhff",
    "issueDate": "2019-06-14",
    "expiryDate": "2025-05-30",
    "reminders": {
      "recurring": false,
      "types": ["DAY_BEFORE", "YEAR_BEFORE"]
    }
  },
];

final List<Map<String, dynamic>> eventCategories = [
  {
    "type": "Birthday",
    "title": null,
    "renewalDays": null,
    "multiple": false,
    "expiryYears": null,
  },
  {
    "type": "Normal",
    "title": null,
    "renewalDays": null,
    "multiple": false,
    "expiryYears": null,
  },
  {
    "type": "Certificate",
    "title": "Driver's License",
    "renewalDays": 30,
    "multiple": true,
    "expiryYears": [3, 5],
  },
  {
    "type": "Certificate",
    "title": "International Passport",
    "renewalDays": 168,
    "multiple": true,
    "expiryYears": [5, 10],
  },
  {
    "type": "Certificate",
    "title": "Business Permit",
    "renewalDays": 30,
    "multiple": false,
    "expiryYears": [2],
  },
  {
    "type": "Certificate",
    "title": "National Identity Card",
    "renewalDays": 30,
    "multiple": false,
    "expiryYears": [10],
  },
  {
    "type": "Certificate",
    "title": "Certificate of Roadworthiness",
    "renewalDays": 30,
    "multiple": false,
    "expiryYears": [1],
  }
];

// Future<List<Event>> fetchEvents() async {
//   print('Entered');
//   final response =
//       await http.get(Uri.parse('http://localhost:8080/api/events/uid/123'));

//   print(response.statusCode);

//   if (response.statusCode == 200) {
//     List<Event> events = [];
//     List<dynamic> jsonList = json.decode(response.body);

//     jsonList.forEach((json) {
//       events.add(Event.fromJson(json));
//     });

//     return events;
//   } else {
//     throw Exception('Failed to load events');
//   }
// }

Future<List<Event>> fetchEvents(String uid) async {
  // Replace 'localhost' with the appropriate IP address or special address
  final uri = Uri.parse(
      'http://10.0.2.2:8080/api/events/uid/$uid'); // For Android emulator
  // final uri = Uri.parse('http://127.0.0.1:8080/api/events/uid/123'); // For iOS simulator or physical device if the backend is running locally

  final response = await http.get(uri);

  // print(response.statusCode);

  if (response.statusCode == 200) {
    List<Event> events = [];
    List<dynamic> jsonList = json.decode(response.body);

    jsonList.forEach((json) {
      events.add(Event.fromJson(json));
    });

    return events;
  } else {
    throw Exception('Failed to load events');
  }
}

// List<Event> diaryEntries =
//     fetchEvents() as List<Event>;

final List<Map<String, dynamic>> eventTypes = [{}];
