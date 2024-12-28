import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:toodoo/task_data.dart';
import 'tasks_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
        home: const TasksScreen(),
      ),
    );
  }
}

// v1.0.0: <check old stuff>
// Room For Improvement (RFI):
// v1.0.0: Enable scheduling reminder notifications at specified dates and times
// v1.1.0: Enable deleting items by swiping
// v1.1.0: Enable reordering items by long-press
// v1.1.0: Cache tasks list to (data persistence)
