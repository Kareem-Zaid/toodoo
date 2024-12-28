import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskData extends ChangeNotifier {
  final List<Task> tasks = [Task(name: 'Task 1'), Task(name: 'Task 2')];
  // late int index;

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

  void toggleReminderStatus(Task task) {
    task.isReminderOn = !task.isReminderOn;
    notifyListeners();
  }
}
