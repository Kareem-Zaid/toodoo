import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';

class TaskEntryScreen extends StatelessWidget {
  const TaskEntryScreen({super.key, required this.isNew, this.index});
  final int? index;
  final bool isNew;

  void onPressed(
      BuildContext context, TaskData taskData, String newTaskText, int index) {
    if (isNew) {
      taskData.addTask(newTaskText);
    } else {
      taskData.tasks[index].name = newTaskText;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final int index = Provider.of<TaskData>(context).index; // May be temporary
    late String newTaskText; // Catch TextField onChanged text

    return Consumer<TaskData>(builder: (ctx, taskData, kid) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Text(isNew ? 'New Task' : 'Edit Task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                )),
            // ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText:
                    isNew ? 'Enter a new task...' : taskData.tasks[index!].name,
              ),
              onChanged: (newTaskTitle) => newTaskText = newTaskTitle,
              onSubmitted: (value) =>
                  onPressed(ctx, taskData, newTaskText, index!),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.primaryContainer),
              onPressed: () => onPressed(ctx, taskData, newTaskText, index!),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isNew ? 'Add' : 'Update',
                    style: const TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      );
    });
  }
}
