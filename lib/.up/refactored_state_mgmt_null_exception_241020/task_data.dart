import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskData extends ChangeNotifier {
  final List<Task> tasks = [Task(name: 'Task 1'), Task(name: 'Task 2')];

  void addTask(String newTaskName) {
    tasks.add(Task(name: newTaskName));
    notifyListeners();
  }

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

  void addUpdateTask(int index, String newName, bool isNew) {
    if (isNew) {
      tasks.add(Task(name: newName));
    } else {
      tasks[index].name = newName;
    }
    notifyListeners();
  }
}
