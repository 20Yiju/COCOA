import 'package:flutter/material.dart';
//import 'package:study/func/Signin.dart';
import 'package:study/func/app.dart';
//import 'package:study/func/addStudy.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}