import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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
    createDatabase();
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

  //1. create database
  //2. create tables
  //3. open database
  //4. insert in database
  //5. select from database
  //6. update database
  //7. delete database
  void createDatabase() async {
    var database = await openDatabase(
      // the variable databaseObject maybe created before database, because database may take more time
      'todo.db',
      // we change the version when we change the structure of database
      version: 1,
      onCreate: (databaseObject, version) {
        //Id -> auto generate and primary key
        // Title -> String / text
        // Date -> String / text
        //Time -> String / text
        //Statue -> String / text
        databaseObject
            .execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)',
        )
            .then((value) {
          print('Database create successfully');
        })
            .catchError((error) {
          print('Error when creating database ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
