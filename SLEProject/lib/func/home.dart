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
      routes: Routes.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Routes {
  Routes._();
  static const String Info = "/Info";
  static final routes = <String, WidgetBuilder> {
    Info: (BuildContext context) => StudyInfo()
  };
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int current_index =0;
  final List<Widget> _children = [Home(), StudyList(),HeartList(), SettingsUI()];
  var user = FirebaseAuth.instance.authStateChanges();
  FirebaseAuth auth = FirebaseAuth.instance;
  String department ="";
  // List<String> studylist  = ["1", "2", "3"];
  // late var studies = [];
  late List<dynamic> studies = <dynamic>[];
  late int ? count;
  // getdata() async{
  //   await FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString()).get().then((value){
  //     setState(() {
  //       // first add the data to the Offset object
  //       List.from(value["study"]).forEach((element){
  //         //Offset data = new Offset(element);
  //
  //         //then add the data to the List<Offset>, now we have a type Offset
  //         print("studies: " + studies[0]);
  //         studies.add(element);
  //       });
  //
  //     });
  //   });
  // }


  // getdata() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(auth.currentUser!.displayName.toString())
  //       .snapshots()
  //       .listen((DocumentSnapshot ds) {
  //     studies = ds["study"];
  //     print(studies[0]);
  //     count = studies.length;
  //     //print(count);
  //   });
  // }
  // @override
  // void intiState() {
  //   super.initState();
  //   getdata();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.displayName.toString()).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot);
    },
  );
}

Widget _buildList(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  FirebaseAuth auth = FirebaseAuth.instance;
  int current_index = 0;
  final List<Widget> _children = [Home(), StudyList(),HeartList(), SettingsUI()];
  late List<dynamic>? studies = <dynamic>[];
  late List<dynamic>? heart = <dynamic>[];

  /*if(snapshot.data!["heart"] != null){
    snapshot.data!["heart"].forEach((element) {
      heart.add(element);
    });
  }

  if(snapshot.data!["study"] != null){
    snapshot.data?["study"].forEach((element) {
      studies.add(element);
    });
    print(studies[0]);

    print("찍어줘: ${snapshot.data?["study"]}");

  }*/
  try{
    snapshot.data!["heart"].forEach((element) {
      heart.add(element);
    });

    snapshot.data!["study"].forEach((element) {
      studies.add(element);
    });

  } on StateError catch(e){
    //heart.add(null);
    //studies.add(null);

  }




  return Scaffold(
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
                  )//,-- border radius here
              ),
              child: Center(
                child: Container(
                  padding: new EdgeInsets.all(30.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("${auth.currentUser!.displayName.toString()}" ,style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),

            ),
          ),
          ),),

        Expanded(
          child:
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemCount: studies.length,
              itemBuilder: (context, i) {
                return SizedBox(
                  height: 80, width: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0, ),
                        Text(studies[i]),
                        TextButton(
                            child: Text("이동",
                                style: TextStyle(color:Color(0xff485ed9))),
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) => Info(study: studies[i])));
                              Navigator.of(context).pushNamed(Routes.Info, arguments: {"study": studies[i]});
                            }

                        ),
                      ],

                    ),

                  ),
                );
              }
          ),
        ),

        SizedBox(height: 150),
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