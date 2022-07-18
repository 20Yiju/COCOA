import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/func/studyInfo.dart';
import 'package:study/func/studyList.dart';
import 'package:study/func/profile.dart';
import 'package:study/func/heartList.dart';
import 'package:study/func/addStudy.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int current_index =0;
  final List<Widget> _children = [Home(), MyApp(),HeartList(), SettingsUI()];
  var user = FirebaseAuth.instance.authStateChanges();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Flexible(child: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        //     Color(0xff3B4383),
                        Color(0xff485ed9),
                       // Color(0xff485ed9).
                        //  Color(0xffA67E90),
                        Color(0xffd4d9f5),

                        //  Color(0xffd1a6d5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft:
                        Radius.circular(30)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/user.png'),
                    scale: 7
                  )// <--- border radius here
                ),
              ),
            ),
            ),),
          TextButton(
            child: Text(auth.currentUser!.displayName.toString(), 
            style: TextStyle(color:Color(0xff485ed9))),
            onPressed: () {
              // final userCollectionReference  = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString());
              // userCollectionReference.get().then((value) =>
              //     print(value.data()!["age"])
              // );
              FirebaseFirestore.instance.collection('users').snapshots().
                  listen((data) {
                      print(data.docs[0]['userName']);
              });
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Info()));
            },
          ),

          SizedBox(height: 270),
          Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Color(0xff485ed9)
                  ),
                ),


                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddStudy()),
                    );
                  },
                child: Text('새로운 스터디 만들기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              )
          ),
          SizedBox(height: 20,),

          ],

      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: current_index,
          onTap: (index) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _children[index]),
            );
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,color:Color(0xff485ed9),),
                label: '홈',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '검색'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '찜'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: '내정보'
            ),
          ],
          selectedItemColor: Color(0xff485ed9),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );


  }
  List body_item = [
    Text('홈'),
    Text('검색'),
    Text('찜'),
    Text('내정보'),
  ];
}