import 'package:flutter/material.dart';

class Task {
  String name;
  int id;
  bool isDone;
  bool isReminderOn;
  DateTime date;
  TimeOfDay time;
  Repeat repeat;

  static int _currentId = 1; // Shared among all instances

  // Private constructor to force the use of factory (for internal use)
  Task._({
    required this.name,
    required this.isDone,
    required this.isReminderOn,
    required this.repeat,
    required this.date,
    required this.time,
    required this.id,
  });

  // Factory constructor that increments ID and creates Task instances
  factory Task({
    required String name,
    bool isDone = false,
    bool isReminderOn = false,
    Repeat repeat = Repeat.off,
    DateTime? date,
    TimeOfDay? time,
  }) {
    return Task._(
      name: name,
      isDone: isDone,
      isReminderOn: isReminderOn,
      repeat: repeat,
      date: date ?? DateTime.now(), // Default to current date if null
      time: time ?? TimeOfDay.now(), // Default to current time if null
      id: _currentId++, // Increment and assign the ID
    );
  }

  DateTime get dateTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

enum Repeat { off, daily, weekly, monthly, yearly }
