import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  String title;
  String description;
  String type;
  DateTime date;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() {
      return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}