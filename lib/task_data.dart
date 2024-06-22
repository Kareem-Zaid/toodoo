import 'package:flutter/material.dart';
import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [Task(taskName: 'Task 1'), Task(taskName: 'Task 2')];

  void addTask(String newTaskName) {
    tasks.add(Task(taskName: newTaskName));
    notifyListeners();
  }

  void updateTask({required int index, required bool toggledValue}) {
    tasks[index].isDone = toggledValue;
    // This is the toggler of boolean "isDone" variable (1)
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}
