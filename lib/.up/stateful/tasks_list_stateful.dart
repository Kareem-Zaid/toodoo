import 'package:flutter/material.dart';
// import 'package:toodoo/task_tile.dart';
import 'task.dart';

class TasksList extends StatefulWidget {
  const TasksList(
      {super.key, required this.tasklist, required this.removeTask});
  final Function removeTask;
  final List<Task> tasklist;
  // When you wanna use such a variable above, which is declared in the stateless part of the stateful widget, you must write "widget." 1st when you use it inside the stateful part. (1)

  // void kareemZaid() {tasklist;} // WITHOUT "widget." like here (1)

  @override
  State<TasksList> createState() => _TasksListState();
}

// void kareemZaid() {widget.tasklist;}(1)
// This fails even with "widget.", as variable is LOCAL & requested here in a GLOBAL place (1)

class _TasksListState extends State<TasksList> {
  //   void kareemZaid() {widget.tasklist;} // ... WITH "widget." like here (1)

  @override
  Widget build(BuildContext context) {
    //   void kareemZaid() {widget.tasklist;} // ... AND here (1)
    return ListView.builder(
      itemCount: widget.tasklist.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(widget.tasklist[index].taskName,
            style: TextStyle(
                decoration: widget.tasklist[index].isDone
                    ? TextDecoration.lineThrough
                    : null)),
        trailing: Checkbox(
            value: widget.tasklist[index].isDone,
            onChanged: (newValue) {
              setState(() {
                widget.tasklist[index].isDone = newValue!;
                // This is the toggler of "isDone" (3)
              });
            }),
        onLongPress: () {
          widget.removeTask(index);
        },
      ),
    );
  }
}
