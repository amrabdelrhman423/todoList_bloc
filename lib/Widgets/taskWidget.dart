import 'package:flutter/material.dart';
import 'package:todolist/shared/cubit/cubit.dart';

class Taskwidget extends StatelessWidget {
  String tasktitle, date, time;
  int id;
  Taskwidget(
      {@required this.tasktitle,
      @required this.time,
      @required this.date,
      @required this.id});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('$id'),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: id);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(time),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tasktitle,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context).updateData(status: 'done', id: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.archive,
                  color: Colors.grey,
                ),
                onPressed: () {
                  AppCubit.get(context).updateData(status: 'arcive', id: id);
                }),
          ],
        ),
      ),
    );
  }
}
