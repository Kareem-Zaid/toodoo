import 'package:flutter/material.dart';

class Task {
  String name;
  int id;
  bool isDone;
  bool isReminderOn;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Repeat selectedRepeat;

  // final int id = DateTime.now().millisecondsSinceEpoch; // Works also
  Task({
    required this.name,
    this.isDone = false,
    this.isReminderOn = false,
    this.selectedRepeat = Repeat.off,
  })  : id = DateTime.now().millisecondsSinceEpoch,
        selectedDate = DateTime.now(),
        selectedTime = TimeOfDay.now();

  DateTime get dateTime {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }
}

enum Repeat { off, daily, weekly, monthly, yearly }
