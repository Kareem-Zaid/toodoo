import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_data.dart';
import 'package:toodoo/utils/date_time_extensions.dart';
import 'task_model.dart';

final LocalNotifsService _localNotifs = LocalNotifsService();

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (ctx, taskData, enfant) {
      final Task task = taskData.tasks[index];

      return Padding(
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
                onChanged: (value) {
                  taskData.toggleReminderStatus(task);
                  debugPrint('task.isReminderOn: ${task.isReminderOn}');
                },
              ),
            ),
            ListTile(
              enabled: task.isReminderOn,
              title: const Text('Select date'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(task.date.toDdMmYyyy()),
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

                if (pickedDate != null) task.date = pickedDate;
              },
            ),
            ListTile(
              enabled: task.isReminderOn,
              title: const Text('Select time'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(task.date.to12H()),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) task.time = pickedTime;
              },
            ),
            ListTile(
              enabled: task.isReminderOn,
              title: const Text('Repeat interval'),
              trailing: DropdownButton<Repeat>(
                value: task.repeat,
                items: const [
                  DropdownMenuItem(value: Repeat.off, child: Text('Off')),
                  DropdownMenuItem(value: Repeat.daily, child: Text('Daily')),
                ],
                onChanged:
                    task.isReminderOn ? (value) => task.repeat = value! : null,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Schedule/cancel task reminder on "Confirm"
                    if (task.isReminderOn) {
                      await _localNotifs.scheduleTaskReminder(
                          task.id, task.dateTime, task.repeat, task.name);
                    } else {
                      await _localNotifs.cancelNotification(task.id);
                    }
                    if (context.mounted) Navigator.pop(context);
                    // Doesn't pop without context
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
