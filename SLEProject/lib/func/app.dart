import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study/func/pages/home2.dart';

class App extends StatelessWidget {
  const App({Key ?key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Firebase load fail"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Home2();
        }
        return CircularProgressIndicator();
      },
    );
  }
}


