import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Widgets/textfelid.dart';
import 'package:todolist/const.dart';
import 'package:todolist/modules/archive_tasks.dart';
import 'package:todolist/modules/done_tasks.dart';
import 'package:todolist/modules/tasks.dart';
import 'package:todolist/shared/cubit/cubit.dart';
import 'package:todolist/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStastes>(listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(appCubit.titels[appCubit.currentIndex]),
          ),
          body: appCubit.newTasks.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : appCubit.screens[appCubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (appCubit.isopenbottomsheet) {
                if (formKey.currentState.validate()) {
                  appCubit.insetDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                  // insetDatabase(
                  //         title: titleController.text,
                  //         date: dateController.text,
                  //         time: timeController.text)
                  //     .then((value) {
                  //   getDatabase(database).then((value) {
                  //     Navigator.pop(context);
                  //     // setState(() {
                  //     //   isopenbottomsheet = !isopenbottomsheet;
                  //     //   tasks = value;
                  //     // });
                  //   });
                  // });
                }
              } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(15),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //title
                              defaultTextField(
                                  titleController,
                                  TextInputType.text,
                                  Icon(Icons.title), (String value) {
                                if (value.isEmpty) {
                                  return "title must not be empty";
                                } else {
                                  return null;
                                }
                              }, "Title"),
                              //time
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  timeController,
                                  TextInputType.datetime,
                                  Icon(Icons.watch_later_rounded),
                                  (String value) {
                                    if (value.isEmpty) {
                                      return "Time must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  "Time",
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context);
                                    });
                                  }),
                              //date
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  dateController,
                                  TextInputType.datetime,
                                  Icon(Icons.calendar_today),
                                  (String value) {
                                    if (value.isEmpty) {
                                      return "Date must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  "Date",
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-12-12'))
                                        .then((value) {
                                      print(DateFormat.yMMMd().format(value));
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  appCubit.changeBottomSheetState(isShow: false);
                  // setState(() {
                  //   isopenbottomsheet = !isopenbottomsheet;
                  // });
                });
                appCubit.changeBottomSheetState(isShow: true);

                // setState(() {
                //   isopenbottomsheet = !isopenbottomsheet;
                // });
              }
            },
            child: Icon(appCubit.isopenbottomsheet ? Icons.add : Icons.edit),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appCubit.currentIndex,
            onTap: (index) {
              appCubit.changeIndex(index);
              // setState(() {
              //   _currentIndex = index;
              // });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: "Done"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: "Archive"),
            ],
          ),
        );
      }),
    );
  }
}
