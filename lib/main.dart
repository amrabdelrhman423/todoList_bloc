import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'Screens/Home.dart';
import 'shared/cubit/blocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
