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

/*
Room For Improvement (RFI):
- Adding more modern delete option
- Enabling reordering items by long-press
- Caching list changes
*/