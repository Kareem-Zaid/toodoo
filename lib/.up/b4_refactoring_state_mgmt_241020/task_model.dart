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
  })  : id = DateTime.now().millisecondsSinceEpoch ~/ 1000, // <= 32 bits
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
