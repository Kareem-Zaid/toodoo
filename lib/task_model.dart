import 'package:flutter/material.dart';

class Task {
  String name;
  int id;
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
    required this.id,
  })  : date = DateTime.now(),
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

enum Repeat { off, hourly, daily, weekly, monthly, yearly }
