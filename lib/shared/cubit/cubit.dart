import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/modules/archive_tasks.dart';
import 'package:todolist/modules/done_tasks.dart';
import 'package:todolist/modules/tasks.dart';
import 'package:todolist/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStastes> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  Database database;
  int currentIndex = 0;
  List<Widget> screens = [Tasks(), DoneTasks(), ArchiveTasks()];
  List<String> titels = ["New Tasks", "Done Tasks", "Archive Tasks"];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isopenbottomsheet = false;
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() async {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      //id integer
      //title String
      //date String
      //time String
      //status String
      print("database Created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT ,time TEXT,status TEXT)')
          .then((value) => print("Table Created"))
          .catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (database) {
      getDatabase(database);
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insetDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              "INSERT INTO tasks(title,date,time,status) VALUES('$title','$date','$time','new')")
          .then((value) {
        print('${value}  inserted Successfully');
        emit(AppInsertDatabaseState());
        getDatabase(database);
      }).catchError((onError) {
        print(onError.toString());
      });
      return null;
    });
  }

  void updateData({@required String status, @required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());

      getDatabase(database);
    });
  }

  void deleteData({@required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeletDatabaseState());

      getDatabase(database);
    });
  }

  void getDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
    //{id: 1, title: first task, date: 02158, time: 891, status: new}
  }

  void changeBottomSheetState({
    @required bool isShow,
  }) {
    isopenbottomsheet = isShow;
    emit(AppChangeBottomSheetState());
  }
}
