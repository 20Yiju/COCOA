import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/func/pages/login.dart';
import '../home.dart';

class Home2 extends StatelessWidget {
  const Home2({Key ?key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (!snapshot.hasData) {
                return Login();
              }
              else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${snapshot.data?.displayName}님 반갑습니다:D"),
                      TextButton(
                          child: Text('로그아웃'),
                        onPressed: () {
                            FirebaseAuth.instance.signOut();
                        },
                      ),
                      TextButton(
                        child: Text('시작하기'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                        },
                      ),
                    ],
                  ),
                );
              }
            },

          ),
    ),
    );

  }
}