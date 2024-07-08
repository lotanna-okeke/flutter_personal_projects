class Event {
  final int id;
  final String uid;
  final String category;
  final String title;
  final String content;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final int? renewalDays;
  final bool recurring;
  final List<String> reminderTypes;

  Event({
    required this.id,
    required this.uid,
    required this.category,
    required this.title,
    required this.content,
    this.issueDate,
    this.expiryDate,
    this.renewalDays,
    required this.recurring,
    required this.reminderTypes,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      uid: json['uid'],
      category: json['category'],
      title: json['title'],
      content: json['content'],
      issueDate:
          json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      renewalDays: json['renewalDays'],
      recurring: json['reminders']['recurring'],
      reminderTypes: List<String>.from(json['reminders']['types']),
    );
  }
}
