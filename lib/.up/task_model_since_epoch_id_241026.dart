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
        // This is catastrophic, as initial tasks get the same id as they are
        // assigned their ids at almost the same time, which is divided by 1000
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
