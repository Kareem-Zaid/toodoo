import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
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
        child: ListView.builder(
          itemCount: taskData.tasks.length,
          itemBuilder: (ctx, index) => Card(
            child: ListTile(
              title: Text(taskData.tasks[index].taskName,
                  style: TextStyle(
                      decoration: taskData.tasks[index].isDone
                          ? TextDecoration.lineThrough
                          : null)),
              trailing: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: taskData.dateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 62),
                        // DateTime.now().add(const Duration(days: 365 * 62)),
                      );

                      if (pickedDate == null || !ctx.mounted) return;

                      TimeOfDay? pickedTime = await showTimePicker(
                        context: ctx,
                        initialTime: const TimeOfDay(hour: 7, minute: 27),
                      );

                      if (pickedTime == null) return;

                      // Put dateTime in Provider data
                      taskData.dateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      // Show dialog of a list of tiles: off, daily #Repeat_Interval
                      if (!ctx.mounted) return;

                      showDialog(
                          context: ctx,
                          builder: (c) => AlertDialog(
                                title: const Text('Repeat'),
                                content: ListView(
                                  children: [
                                    ListTile(
                                      title: const Text('Off'),
                                      onTap: () {},
                                    ),
                                    ListTile(
                                      title: const Text('Daily'),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                shape: const CircleBorder(),
                              ));

                      await _localNotifs.scheduleTaskReminder(
                          index, taskData.dateTime, false);
                    },
                    icon: const Icon(Icons.schedule),
                  ),
                  Checkbox(
                      value: taskData.tasks[index].isDone,
                      onChanged: (newValue) {
                        taskData.updateTask(
                            index: index, toggledValue: newValue!);
                      }),
                ],
              ),
              onLongPress: () {
                taskData.removeTask(index);
              },
            ),
          ),
        ),
      );
    });
  }
}
