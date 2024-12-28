import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_model.dart';
import 'task_data.dart';

final LocalNotifsService _localNotifs = LocalNotifsService();

class TaskEntryScreen extends StatelessWidget {
  const TaskEntryScreen({super.key, this.index});
  final int? index;

  @override
  Widget build(BuildContext context) {
    String? newName; // Catch TextField onChanged text
    bool isNew = index == null;
    final TextEditingController controller = TextEditingController();

    return Consumer<TaskData>(builder: (ctx, taskData, kid) {
      Task? task;
      if (!isNew) {
        task = taskData.tasks[index!];
        controller.text = task.name;
      }

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
              // textAlign: TextAlign.center,
              controller: controller,
              // decoration: InputDecoration(hintText: task.name),
              decoration: const InputDecoration(hintText: 'Enter task name...'),
              onChanged: (newTaskText) => newName = newTaskText,
              // onSubmitted: (value) => taskData.addUpdateTask(index!, newName, isNew, context),
              // Useful for Web and Windows run; lets "Enter" work like ElevatedButton "onPressed"
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(ctx).colorScheme.primaryContainer),
                onPressed: () async {
                  if (newName != null && newName!.trim().isNotEmpty) {
                    taskData.addUpdateTask(index, newName!);

                    if (task != null) {
                      // Reschedule reminder if on & task is "Not Done" to update body
                      if (/* !isNew &&  */ task.isReminderOn && !task.isDone) {
                        await _localNotifs.scheduleTaskReminder(
                            task.id, task.dateTime, task.repeat, task.name);
                      }
                    }

                    if (context.mounted) Navigator.pop(context);
                  } else if (newName == null && !isNew) {
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(msg: 'Task name field is empty');
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Enter task name')));
                  }
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      isNew ? 'Add' : 'Update',
                      style: const TextStyle(color: Colors.black),
                    )),
              ),
            ),
          ],
        ),
      );
    });
  }
}
