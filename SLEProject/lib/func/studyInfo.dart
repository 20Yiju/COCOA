import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';
import 'package:study/func/calendar.dart';
import 'package:get/get.dart';

import 'chat.dart';
late List<dynamic> name = <dynamic>[];
late List<dynamic> achieve = <dynamic>[];
late Map<String, int> achievements = {};
late List<int> pct = <int>[];

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Suit',
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        title: "Study Info",
        initialRoute: 'StudyInfo',
        routes: {
          "StudyInfo": (context) =>  StudyInfo(),
          'calendar': (context) =>  Calendar(appbarTitle: '',),
        }
      // home: StudyInfo(),
    );
  }
}

class StudyInfo extends StatefulWidget {
  @override
  _StudyInfo createState() => _StudyInfo();
}

class _StudyInfo extends State<StudyInfo> {
  late final study;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map arguments = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    if (arguments != null) {
      study = arguments["study"] as String;
      print("studystudystudy!!!!!!!!!!!: " + study);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context, study),
    );
  }
}

Widget _buildBody(BuildContext context, String study) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('study').doc(study).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildBody2(context, snapshot, study);
    },
  );
}

Widget _buildBody2(BuildContext context, AsyncSnapshot<DocumentSnapshot> studySnapshot, String study) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("study").doc(study).collection("calendar").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, studySnapshot, snapshot, study);
    },
  );
}

Widget _buildList(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot, AsyncSnapshot<QuerySnapshot> calendarSnapshot, String study) {
  FirebaseAuth auth = FirebaseAuth.instance;
  final studyReference = FirebaseFirestore
      .instance.collection("users").doc(
      auth.currentUser?.displayName.toString());

  if (!calendarSnapshot.hasData) return LinearProgressIndicator();

  else {
    calendarSnapshot.data!.docs.forEach((element) {
      print("snapshot 반복문 돌아감");
      if (element["date"].compareTo("멤버별성취도") == 0) {
        for(String s in element["member"]) {
          if(!name.contains(s)) name.add(s);
          achievements[s] = element[s]["성취도"];
        }
      }});}

  for(int i = 0; i < name.length; i++) {
    print(name[i] + "\n");
  }
  print("⭐⭐achievements: $achievements");
  List keys = achievements.keys.toList();

  for (int i = 0; i < achievements.length; i++) {
    int? percentage = achievements[keys[i]];
    print('이야아아아아앗 $percentage');
    pct.add(percentage as int);
  }
  print(pct);


  int current_index = 0;
  final List<Widget> _children = [Info(),Calendar(appbarTitle: study),Chat(appbarTitle: study,)];
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          Icons.home,
          color: Color(0xff485ed9),
        ),
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Home()));},
      ),

    ),
    body: Container(
      padding: EdgeInsets.only(left: 5, top: 25, right: 5),
      child: Builder(
        builder: (context) => Scaffold(
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10,),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                      study,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  )),
              const SizedBox(height: 40),
              Text('방장', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),

              const SizedBox(height: 10),
              Text(snapshot.data!["hostName"], style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              const SizedBox(height: 30),
              Text("카카오톡 오픈채팅방 링크", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),
              const SizedBox(height: 10),
              Text(snapshot.data!["url"], style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              const SizedBox(height: 30),
              Text('멤버별 성취도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),
              const SizedBox(height: 20),
              ListView.builder(
                   shrinkWrap: true,
                   physics : NeverScrollableScrollPhysics(),
                   itemCount: name.length,
                   itemBuilder: (context, index) {

                     return Container(
                       child: Container (
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('${keys[index]}', style:TextStyle(fontSize: 15)),
                             const SizedBox(height: 5),
                             GFProgressBar(
                               percentage: pct[index].toDouble()*0.01,
                               lineHeight: 27,
                               child: Padding(
                                 padding: EdgeInsets.only(right: 20, bottom: 5, top: 3),
                                 child: Text('${achievements[keys[index]]}%', textAlign: TextAlign.end,
                                   style: TextStyle(fontSize: 16, color: Colors.white),
                                 ),
                               ),
                               backgroundColor: Colors.black26,
                               progressBarColor: GFColors.WARNING,
                             ),
                           const SizedBox(height: 20)
                           ]
                         ),
                       ),
                         );
                   },
               ),


              const SizedBox(height: 20),
              TextFieldWidget(
                label: '스터디 설명',
                text: snapshot.data!["description"],
                maxLines: 10,
              ),
              const SizedBox(height: 35),
              Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Color(0xff485ed9)
                      ),
                    ),

                    onPressed: () {
                      if('학부생'+snapshot.data!["hostName"] == auth.currentUser?.displayName.toString()){
                        FirebaseFirestore.instance.collection('study').doc(study).delete();
                        studyReference.update({
                          'study': FieldValue.arrayUnion([
                            study
                          ])
                        });
                        /*FirebaseFirestore.instance.collection('user').doc(auth.currentUser?.displayName.toString()).update(
                            {heart: firebase.firestore.FieldValue.delete()}
                        );*/





                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                      }

                    },
                    child: Text('스터디 삭제',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  )
              ),
              // Center(
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //         shape: MaterialStateProperty.all(
              //           RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20.0)
              //           ),
              //         ),
              //         padding: MaterialStateProperty.all(
              //           const EdgeInsets.fromLTRB(30, 10, 30, 10),
              //         ),
              //         backgroundColor: MaterialStateProperty.all(
              //           //Color.fromARGB(255, 74, 170, 248)
              //             Color(0xff485ed9)
              //         ),
              //       ),
              //
              //       onPressed: () {
              //         Navigator.push(
              //             context, MaterialPageRoute(builder: (context) => Calendar(appbarTitle : study)));
              //         // );
              //       },
              //       child: Text('일정 페이지로 이동',
              //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //
              //     )
              // ),
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
                  icon: Icon(Icons.widgets, color:Color(0xff485ed9),),
                  label: '메인',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event_available),
                    label: '일정'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble),
                    label: '채팅'
                ),
              ],
              selectedItemColor: Color(0xff485ed9),
              // selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
            ),
          ),
        ),
      ),

    ),
  );
}


class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9)),
      ),
      const SizedBox(height: 15),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(100,74,74,74)),
              borderRadius: BorderRadius.circular(20)
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  strutStyle: StrutStyle(fontSize: 10),
                  text: TextSpan(
                      text: widget.text,
                      style: TextStyle(fontSize: 16, color: Colors.grey)
                  )))

            ],
          )
      ),
    ],
  );
}
