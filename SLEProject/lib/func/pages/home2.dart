import 'package:cloud_firestore/cloud_firestore.dart';
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
                final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(snapshot.data?.displayName);
                userCollectionReference.set({
                  "userName": snapshot.data?.displayName,
                  "age": 22,
                });
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${snapshot.data?.displayName}님 반갑습니다:D", style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      TextButton(
                          child: Text('로그아웃', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),),
                        onPressed: () {
                            FirebaseAuth.instance.signOut();
                        },
                      ),
                      TextButton(
                        child: Text('시작하기', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),),

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