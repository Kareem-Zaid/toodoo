import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_entry_screen.dart';
import 'package:toodoo/reminder_screen.dart';
import 'package:toodoo/task_model.dart';
import 'task_data.dart';

final LocalNotifsService _localNotifs = LocalNotifsService();

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
        builder: (contextUsedHereOnly, taskData, childAy7aga) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: taskData.tasks.isEmpty
            ? const Center(child: Text("There are no items."))
            : ListView.builder(
                itemCount: taskData.tasks.length,
                itemBuilder: (ctx, index) {
                  // taskData.index = index;
                  final Task task = taskData.tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task.name,
                          style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // Exceptional
                        children: [
                          IconButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                context: ctx,
                                builder: (c) => ReminderScreen(index: index),
                              );

                              // Schedule task reminder on "Confirm"
                              if (task.isReminderOn) {
                                // if (task.dateTime.isAfter(DateTime.now())) {
                                await _localNotifs.scheduleTaskReminder(task.id,
                                    task.dateTime, task.repeat, task.name);
                                // } else {
                                // Fluttertoast.showToast(
                                //     msg: 'Set a future date/time');
                                // }
                              }
                            },
                            icon: const Icon(Icons.schedule),
                          ),
                          Checkbox(
                              value: task.isDone,
                              onChanged: (newValue) async {
                                taskData.toggleTaskStatus(index);
                                // Cancel/schedule only if reminder is on
                                if (task.isReminderOn) {
                                  if (task.isDone) {
                                    // Cancel task reminder if marked as "Done"
                                    await _localNotifs
                                        .cancelNotification(task.id);
                                  } else {
                                    // Reschedule task reminder if marked as "Not Done"
                                    await _localNotifs.scheduleTaskReminder(
                                        task.id,
                                        task.dateTime,
                                        task.repeat,
                                        task.name);
                                  }
                                }
                              }),
                        ],
                      ),
                      onTap: () {
                        // Update task details (name)
                        showModalBottomSheet(
                          context: context,
                          builder: (c) => TaskEntryScreen(index: index),
                        );
                      },
                      onLongPress: () async {
                        await _localNotifs.cancelNotification(task.id);
                        taskData.removeTask(index);
                      },
                    ),
                  );
                },
              ),
      );
    });
  }
}
