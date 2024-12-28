import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskData extends ChangeNotifier {
  final List<Task> tasks = [Task(name: 'Task 1'), Task(name: 'Task 2')];

  // May need their methods to be here, and include with "notifyListeners()"
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isReminderOn = false;
  Repeat selectedRepeat = Repeat.off;

  void addTask(String newTaskName) {
    tasks.add(Task(name: newTaskName));
    notifyListeners();
  }

  void toggleTaskStatus({required int index, required bool toggledValue}) {
    tasks[index].isDone = toggledValue;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}
