import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';
// import 'task.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key, required this.addTask});
  final Function addTask;

  @override
  Widget build(BuildContext context) {
    late String newTaskText;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch, (2)
        // CrossAxisAlignment.stretch overrides "SizeBox" width constraints
        children: [
          // Center(child:
          Text('New Task',
              // textAlign: TextAlign.center, // No need when no column cross axis stretch (2)
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              )),
          // ),
          TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (newTaskTitle) {
              // setState(() {}); // The method 'setState' isn't defined for StatelessWidget
              newTaskText = newTaskTitle;
              // This must be so as to assign - & catch - the value of the local variable  of the "onChanged" anonymous function to another variable that can be used elsewhere
            },
            onSubmitted: (value) {
              Provider.of<TaskData>(context, listen: false)
                  .addTask(newTaskText);
              Navigator.pop(context);
              // This "onSubmitted" function functions as the function of "Enter" key press, and in this example it executes the same code of the "Add" button's "onPressed"
            },
          ),
          const Spacer(),
          SizedBox(
            width: 150,
            // height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              onPressed: () {
                Provider.of<TaskData>(context, listen: false)
                    .addTask(newTaskText);
                Navigator.pop(context);
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add',
                      style: TextStyle(color: Colors.black, fontSize: 24))),
            ),
          )
        ],
      ),
    );
  }
}
