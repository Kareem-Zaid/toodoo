import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_data.dart';
import 'package:toodoo/utils/date_time_extensions.dart';
import 'task_model.dart';

LocalNotifsService _localNotifs = LocalNotifsService();

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (ctx, taskData, enfant) {
      final Task task = taskData.tasks[index];
      if (!task.isReminderOn) task.time = TimeOfDay.now();

      return PopScope(
        canPop: !task.isReminderOn || task.dateTime.isAfter(DateTime.now()),
        onPopInvokedWithResult: (didPop, result) {
          if (task.isReminderOn && !task.dateTime.isAfter(DateTime.now())) {
            debugPrint('Set a future date/time');
            Fluttertoast.showToast(msg: 'Set a future date/time');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Reminder Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Enable Reminder'),
                trailing: Switch(
                  value: task.isReminderOn,
                  onChanged: (value) async {
                    taskData.toggleTaskReminder(index);
                    debugPrint('task.isReminderOn: ${task.isReminderOn}');
                    if (!task.isReminderOn) {
                      // Cancel task reminder on switching off
                      await _localNotifs.cancelNotification(task.id);
                    }
                  },
                ),
              ),
              ListTile(
                enabled: task.isReminderOn,
                title: const Text('Select date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(task.dateTime.toDdMmYyyy()),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: task.date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 62),
                  );

                  if (pickedDate != null) {
                    taskData.setTaskDate(index, pickedDate);
                  }
                },
              ),
              ListTile(
                enabled: task.isReminderOn,
                title: const Text('Select time'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(task.dateTime.to12H()),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: DateTime.now().add(const Duration(minutes: 1)).hour,
                      minute:
                          DateTime.now().add(const Duration(minutes: 1)).minute,
                    ),
                  );

                  if (pickedTime != null) {
                    taskData.setTaskTime(index, pickedTime);
                  }
                },
              ),
              ListTile(
                enabled: task.isReminderOn,
                title: const Text('Repeat interval'),
                trailing: DropdownButton<Repeat>(
                  value: task.repeat,
                  items: const [
                    DropdownMenuItem(value: Repeat.off, child: Text('Off')),
                    DropdownMenuItem(
                        value: Repeat.hourly, child: Text('Hourly')),
                    DropdownMenuItem(value: Repeat.daily, child: Text('Daily')),
                    DropdownMenuItem(
                        value: Repeat.weekly, child: Text('Weekly')),
                    DropdownMenuItem(
                        value: Repeat.monthly, child: Text('Monthly')),
                    DropdownMenuItem(
                        value: Repeat.yearly, child: Text('Yearly')),
                  ],
                  onChanged: task.isReminderOn
                      ? (value) => taskData.setTaskRepeat(index, value!)
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
