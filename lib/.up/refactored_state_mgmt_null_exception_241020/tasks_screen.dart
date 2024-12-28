import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_entry_screen.dart';
import 'task_data.dart';
import 'task_list.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int taskCount = Provider.of<TaskData>(context).tasks.length;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Task',
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => const TaskEntryScreen(isNew: true),
        ),
      ),
      backgroundColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(.727),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 35, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_outlined,
                  color: Colors.white.withOpacity(.85),
                  size: 32,
                ),
                const SizedBox(width: 20),
                Text('Too-Doo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    )),
              ],
            ),
            Text('$taskCount ${taskCount == 1 ? 'Task' : 'Tasks'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(.85),
                  fontSize: 16,
                )),
            const SizedBox(height: 15),
            const Center(
                child: Text('Tap any task to modify & Long press to delete',
                    style: TextStyle(color: Colors.white))),
            const SizedBox(height: 5),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: const TaskList(),
            )),
            const SizedBox(height: 27),
          ],
        ),
      ),
    );
  }
}
