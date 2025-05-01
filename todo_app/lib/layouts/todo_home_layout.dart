import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';

class TodoHomeLayout extends StatefulWidget {
  const TodoHomeLayout({super.key});

  @override
  State<TodoHomeLayout> createState() => _TodoHomeLayoutState();
}

class _TodoHomeLayoutState extends State<TodoHomeLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int currentIndex = 0;

  List<String> labels = ['Tasks', 'Done Tasks', 'ArchivedTasks'];

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(labels[currentIndex])),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived ',
          ),
        ],
      ),
    );
  }
}
