import 'package:flutter/material.dart';

class Task {
  String name;
  int id;
  static int _currentId = 1; // Shared among all instances
  bool isDone;
  bool isReminderOn;
  DateTime date;
  TimeOfDay time;
  Repeat repeat;

  Task({
    required this.name,
    this.isDone = false,
    this.isReminderOn = false,
    this.repeat = Repeat.off,
  })  : id = _currentId++, // Increment and assign the ID
        date = DateTime.now(),
        time = TimeOfDay.now();

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
