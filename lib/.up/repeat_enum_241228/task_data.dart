import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskData extends ChangeNotifier {
  final List<Task> tasks = [
    Task(name: '''Welcome to Too-Doo
    Control tasks as you like''', id: 0),
    // Task(name: 'Control tasks as you like', id: 98),
  ];

  int _currentId = 1;

  void toggleTaskStatus(int index) {
    tasks[index].isDone = !tasks[index].isDone;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTaskReminder(int index) {
    tasks[index].isReminderOn = !tasks[index].isReminderOn;
    notifyListeners();
  }

  void setTaskDate(int index, DateTime pickedDate) {
    tasks[index].date = pickedDate;
    notifyListeners();
  }

  void setTaskTime(int index, TimeOfDay pickedTime) {
    tasks[index].time = pickedTime;
    notifyListeners();
  }

  void setTaskRepeat(int index, Repeat repeat) {
    tasks[index].repeat = repeat;
    notifyListeners();
  }

  void addUpdateTask(int? index, String newName) {
    if (index == null) {
      tasks.add(Task(name: newName, id: _currentId++));
    } else {
      tasks[index].name = newName;
    }
    debugPrint('Last added task id: ${tasks.last.id}');
    notifyListeners();
  }

  void deleteAllTasks() {
    tasks.clear();
    notifyListeners();
  }
}
