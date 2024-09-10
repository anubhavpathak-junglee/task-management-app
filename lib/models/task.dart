import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Priority { low, medium, high }

class Task {
  int? id;
  String title;
  String description;
  String dueDateTime;
  Priority priority;
  bool repeat;
  bool isCompleted;
  String createdAt;

  Task({
    this.id, 
    required this.title, 
    required this.description, 
    required this.dueDateTime, 
    required this.priority, 
    required this.repeat,
    this.isCompleted = false, 
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDateTime': dueDateTime,
      'priority': priority.index,
      'repeat': repeat ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDateTime: map['dueDateTime'],
      priority: Priority.values[map['priority']],
      repeat: map['repeat'] == 1,
      isCompleted: map['isCompleted'] == 1,
      createdAt: map['createdAt'],
    );
  }

  DateTime get createdDateTime {
    return DateFormat('d MMM, y').parse(createdAt);
  }

  DateTime dateTime() {
    DateFormat dateFormat = DateFormat('d MMM, y, HH:mm');
    return dateFormat.parse(dueDateTime);
  } 

  TimeOfDay timeOfDay() {
    DateFormat dateFormat = DateFormat('d MMM, y, HH:mm');
    DateTime dateTime = dateFormat.parse(dueDateTime);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String toStringDateTime(DateTime dateTime, TimeOfDay? time) {
    if (time != null) {
      return DateFormat('d MMM, y, HH:mm').format(DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute));
    }
    return DateFormat('d MMM, y, HH:mm').format(dateTime);
  }

  void updateDueDate() {
    if (repeat) {
      DateTime now = DateTime.now();
      dueDateTime = Task.toStringDateTime(DateTime(now.year, now.month, now.day+1), timeOfDay());
    }
  }
}
