import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:toodoo/task_tile.dart';
// import 'task.dart';
import 'task_data.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    // required this.removeTask,
  });
  // final Function removeTask;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
        builder: (contextUsedHereOnly, taskData, childAy7aga) {
      return ListView.builder(
        itemCount: taskData.tasks.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(taskData.tasks[index].taskName,
              style: TextStyle(
                  decoration: taskData.tasks[index].isDone
                      ? TextDecoration.lineThrough
                      : null)),
          trailing: Checkbox(
              value: taskData.tasks[index].isDone,
              onChanged: (newValue) {
                // Here I ignore the newValue and instead I use my own toggler (1)
                // Edit: I ignore the above ignore, and use newValue in toggling (1)
                taskData.updateTask(index: index, toggledValue: newValue!);
                // taskData.notifyListeners(); // notifyListeners();
                // The above method calls don't work here in TaskList widget as the widget doesn't extend ChangeNotifier, unlike TaskData class
              }),
          onLongPress: () {
            taskData.removeTask(index);
          },
        ),
      );
    });
  }
}
