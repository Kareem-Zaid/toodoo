import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:toodoo/local_notifs_service.dart';
import 'package:toodoo/task_data.dart';
import 'tasks_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await LocalNotifsService().initLocalNotifs();
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Too-Doo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const TasksScreen(),
      ),
    );
  }
}

// v1.0.0: Tasks screen, showing number of current tasks, and task list {240617}
// v1.0.0: Mark tasks as completed through a checkbox {240617}
// v1.0.0: Button for adding new tasks, and long press task item to remove {240618}
// v1.0.0: Use Provider for state management {240621}
// v1.0.0: Enable scheduling reminder notifications at specified dates & times {241017}
// v1.0.0: Enable scheduling notifications with a repeat interval {241017}
// v1.0.0: Enable editing task title by tapping on it {241020}
// v1.0.0: Apply data persistence to task data
// [icon, rename]
// v2.0.0: Enable deleting items by swiping
// v2.0.0: Enable reordering items by long-press
// v2.0.0: Cache tasks list to (data persistence)
// v2.1.0: Enable multiple options for repeat feature (instead of "daily" only)
