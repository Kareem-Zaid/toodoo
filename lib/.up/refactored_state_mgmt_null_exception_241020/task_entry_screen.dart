import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_model.dart';
import 'task_data.dart';

final LocalNotifsService _localNotifs = LocalNotifsService();

class TaskEntryScreen extends StatelessWidget {
  const TaskEntryScreen({super.key, required this.isNew, this.index});
  final int? index;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    late String newName; // Catch TextField onChanged text

    return Consumer<TaskData>(builder: (ctx, taskData, kid) {
      final Task task = taskData.tasks[index!];
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
                hintText: isNew ? 'Enter a new task...' : task.name,
              ),
              onChanged: (newTaskText) => newName = newTaskText,
              // onSubmitted: (value) => taskData.addUpdateTask(index!, newName, isNew, context),
              // Useful for Web and Windows run; lets "Enter" work like ElevatedButton "onPressed"
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.primaryContainer),
              onPressed: () async {
                taskData.addUpdateTask(index!, newName, isNew);

                // Reschedule reminder if on & task is "Not Done" to update body
                if (task.isReminderOn && !task.isDone) {
                  await _localNotifs.scheduleTaskReminder(
                      task.id, task.dateTime, task.repeat, task.name);
                }

                if (context.mounted) Navigator.pop(context);
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isNew ? 'Add' : 'Update',
                    style: const TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      );
    });
  }
}
