import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/ui/components/archived_tasks_screen.dart';
import 'package:todo_app/features/home/ui/components/done_tasks_screen.dart';
import 'package:todo_app/features/home/ui/components/new_tasks_screen.dart';
import 'package:todo_app/features/home/ui/components/widgets/bottom_sheet_body.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List newTasks = [];
  List doneTasks = [];
  List archivedTasks = [];
  int currentIndex = 0;
  final List<String> labels = ['Tasks', 'Done Tasks', 'ArchivedTasks'];
  bool isBottomSheetShown = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  changeBottomNavigationBarIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavigationBarState());
  }

  void insertDataToBottomSheet(context) {
    if (isBottomSheetShown) {
      if (BottomSheetBody.formKey.currentState!.validate()) {
        insertToDatabase(
          title: BottomSheetBody.title,
          date: BottomSheetBody.selectedDate,
          time: BottomSheetBody.selectedTime,
          status: 'new',
        ).then((_) {
          getDataFromDatabase(database).then((value) {
            Navigator.pop(context);
            isBottomSheetShown = !isBottomSheetShown;
            emit(InsertDataIntoBottomSheetState());
          });
        });
      }
    } else {
      scaffoldKey.currentState!
          .showBottomSheet(
            elevation: 20,
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple.shade100),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            (c) => BottomSheetBody(),
          )
          .closed
          .then((value) {
            isBottomSheetShown = false;
            emit(InsertDataIntoBottomSheetState());
          });
      isBottomSheetShown = true;
      emit(InsertDataIntoBottomSheetState());
    }
  }

  void updateBottomSheetData({
    required context,
    required int bottomSheetID,
    required String newTitle,
    required String newDate,
    required String newTime,
  }) {
    if (isBottomSheetShown) {
      if (BottomSheetBody.formKey.currentState!.validate()) {
        updateDataInDatabase(
          title: newTitle,
          date: newDate,
          time: newTime,
          id: bottomSheetID,
        ).then((_) {
          getDataFromDatabase(database).then((value) {
            Navigator.pop(context);
            isBottomSheetShown = !isBottomSheetShown;
            emit(UpdateDataIntoBottomSheetState());
          });
        });
      }
    } else {
      scaffoldKey.currentState!
          .showBottomSheet(
            elevation: 20,
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple.shade100),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            (c) => BottomSheetBody(),
          )
          .closed
          .then((value) {
            isBottomSheetShown = false;
            emit(UpdateDataIntoBottomSheetState());
          });
      isBottomSheetShown = true;
      emit(UpdateDataIntoBottomSheetState());
    }
  }

  //1. create database
  //2. create tables
  //3. open database
  //4. insert in database
  //5. select from database
  //6. update database
  //7. delete database

  late Database database;

  void createDatabase() {
    openDatabase(
      // the variable databaseObject maybe created before database, because database may take more time
      'todo.db',
      // we change the version when we change the structure of database
      version: 1,
      onCreate: (databaseObject, version) {
        //Id -> auto generate and primary key
        //Title -> String / text
        //Date -> String / text
        //Time -> String / text
        //Statue -> String / text
        databaseObject
            .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)',
            )
            .then((value) {
              emit(AppCreateDatabaseState());
            })
            .catchError((error) {
              emit(AppCreateDatabaseErrorState(error: error.toString()));
            });
      },
      onOpen: (database) {
        //هنا استخدمت ال database  لان التانيه بيحصلها creation بعد دي
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
    required String status,
  }) async {
    await database
        .transaction((txn) {
          return txn
              .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES(?, ?, ?, ?)',
                [title, date, time, status],
              )
              .then((v) {
                emit(AppInsertDatabaseState());
                print('inserted successfully');
              });
        })
        .catchError((error) {
          emit(AppInsertDatabaseErrorState(error: error.toString()));
          print('Insert error: ${error.toString()}');
        });
  }

  updateDataInDatabase({
    required String title,
    required String date,
    required String time,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET title = ?, date = ?, time = ? WHERE id = ?',
      [title, date, time, id],
    )

        .then((value) {
          getDataFromDatabase(database);
          emit(UpdateDataIntoBottomSheetState());
        })
        .catchError((error) {
          print('Updated error: ${error.toString()}');
        });
  }

  getDataFromDatabase(database) {
    emit(AppLoadingState());
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM tasks ').then((value) {
      for (var task in value) {
        print('Task ID: ${task['status']}');
      }

      value.map((e) {
        if (e['status'] == 'new') {
          newTasks.add(
            TaskModel(
              id: e['id'],
              title: e['title'],
              date: e['date'],
              time: e['time'],
              status: e['status'],
            ),
          );
        } else if (e['status'] == 'done') {
          doneTasks.add(
            TaskModel(
              id: e['id'],
              title: e['title'],
              date: e['date'],
              time: e['time'],
              status: e['status'],
            ),
          );
        } else {
          archivedTasks.add(
            TaskModel(
              id: e['id'],
              title: e['title'],
              date: e['date'],
              time: e['time'],
              status: e['status'],
            ),
          );
        }
      }).toList();
      emit(AppGetDatabaseState());
    });
  }

  updateTasksStatus({required int id, required String status}) async {
    database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id])
        .then((value) {
          // we must get data again after update database
          getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
        });
  }

  deleteTask({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
