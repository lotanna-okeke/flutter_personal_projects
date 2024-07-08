// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:test/data/data.dart';
// import 'package:test/data/functions.dart';
// import 'package:test/widgets/event_card.dart';
// import 'package:test/widgets/event_seach.dart';
// import 'package:test/widgets/noEntry.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'calendar_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Event>> diaryEntriesFuture;
//   final int _itemsPerPage = 10; // Number of items per page
//   int _currentPage = 0; // Current page index
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();

//     tz.initializeTimeZones();
//     diaryEntriesFuture = fetchEvents();
//   }

//   List<Event> _getPaginatedEntries(List<Event> diaryEntries) {
//     int start = _currentPage * _itemsPerPage;
//     int end = start + _itemsPerPage;
//     return diaryEntries.sublist(
//       start,
//       end > diaryEntries.length ? diaryEntries.length : end,
//     );
//   }

//   void _nextPage(List<Event> diaryEntries) {
//     setState(() {
//       if ((_currentPage + 1) * _itemsPerPage < diaryEntries.length) {
//         _currentPage++;
//       }
//     });
//   }

//   void _prevPage() {
//     setState(() {
//       if (_currentPage > 0) {
//         _currentPage--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String currentDay = DateFormat('d').format(DateTime.now());

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.menu, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: const Text(
//           'Event Echo',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           FutureBuilder<List<Event>>(
//             future: diaryEntriesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container();
//               } else if (snapshot.hasError) {
//                 return IconButton(
//                   icon: Icon(Icons.error, color: Colors.red),
//                   onPressed: () {},
//                 );
//               } else if (snapshot.hasData) {
//                 return IconButton(
//                   icon: Icon(Icons.search, color: Colors.black),
//                   onPressed: () {
//                     showSearch(
//                         context: context,
//                         delegate: EventSearchDelegate(snapshot.data!));
//                   },
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           FutureBuilder<List<Event>>(
//             future: diaryEntriesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container();
//               } else if (snapshot.hasError) {
//                 return IconButton(
//                   icon: Icon(Icons.error, color: Colors.red),
//                   onPressed: () {},
//                 );
//               } else if (snapshot.hasData) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CalendarScreen(diaryEntries: snapshot.data!),
//                             ),
//                           );
//                         },
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             const Icon(Icons.calendar_today,
//                                 color: Colors.black),
//                             Positioned(
//                               top: 8,
//                               child: Text(
//                                 currentDay,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Event>>(
//         future: diaryEntriesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<Event> diaryEntries = snapshot.data!;
//             if (diaryEntries.isEmpty) {
//               return const NoEntry(
//                   icons: Icons.alarm_off_rounded, text: 'No Event');
//             }

//             diaryEntries.sort((a, b) {
//               try {
//                 if (a.expiryDate == null || b.expiryDate == null) {
//                   return 0;
//                 }
//                 DateTime dateA = DateTime.parse(a.expiryDate as String);
//                 DateTime dateB = DateTime.parse(b.expiryDate as String);
//                 return dateA.compareTo(dateB);
//               } catch (e) {
//                 print('Error parsing expiryDate: $e');
//                 return 0;
//               }
//             });

//             List<Event> paginatedEntries = _getPaginatedEntries(diaryEntries);

//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: paginatedEntries.length,
//                     itemBuilder: (context, index) {
//                       bool showDate = index == 0 ||
//                           paginatedEntries[index].expiryDate !=
//                               paginatedEntries[index - 1].expiryDate;
//                       String emoji = determineEmoji(
//                           paginatedEntries[index].expiryDate.toString(),
//                           paginatedEntries[index].category);
//                       return EventCard(
//                         date: paginatedEntries[index].expiryDate.toString(),
//                         gotten: paginatedEntries[index].issueDate.toString(),
//                         title: paginatedEntries[index].title,
//                         emoji: emoji,
//                         content: paginatedEntries[index].content,
//                         showDate: showDate,
//                         reminders: (paginatedEntries[index].reminderTypes
//                                 as List<dynamic>)
//                             .cast<String>(),
//                       );
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (_currentPage > 0)
//                       ElevatedButton(
//                         onPressed: _prevPage,
//                         child: Text(
//                           '<',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     SizedBox(width: 20),
//                     if ((_currentPage + 1) * _itemsPerPage <
//                         diaryEntries.length)
//                       ElevatedButton(
//                         onPressed: () => _nextPage(diaryEntries),
//                         child: Text(
//                           '>',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: Text('No events found'));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {},
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         icon: const Icon(
//           Icons.create,
//           color: Colors.white,
//         ),
//         label: const Text(
//           'Add',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
