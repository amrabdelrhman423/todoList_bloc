import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Widgets/taskWidget.dart';
import 'package:todolist/shared/cubit/cubit.dart';
import 'package:todolist/shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStastes>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);

          return ListView.separated(
            itemCount: appCubit.doneTasks.length,
            itemBuilder: (context, index) {
              return Taskwidget(
                  tasktitle: appCubit.doneTasks[index]['title'],
                  date: appCubit.doneTasks[index]['date'],
                  time: appCubit.doneTasks[index]['time'],
                  id: appCubit.doneTasks[index]['id']);
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
          );
        });
  }
}
