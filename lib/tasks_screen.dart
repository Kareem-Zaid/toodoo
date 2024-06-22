import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'new_task_screen.dart';
// import 'task.dart';
import 'task_data.dart';
import 'tasks_list.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          // By default, backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          tooltip: 'New Task',
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return NewTaskScreen(addTask: (String newTaskTitle) {
                  // setState(() {tasks.add(Task(taskName: newTaskTitle));});
                });
              },
            );
          },
        ),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary.withOpacity(.727),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                Text('${Provider.of<TaskData>(context).tasks.length} Tasks',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontSize: 16,
                    )),
                const SizedBox(height: 20),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: const TasksList(
                      // tasklist: tasks,
                      // removeTask: (int nDx) {setState(() {tasks.removeAt(nDx);});},
                      ),
                )),
                const SizedBox(height: 27),
              ],
            )));
  }
}
