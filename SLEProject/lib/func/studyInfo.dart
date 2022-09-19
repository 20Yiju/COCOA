import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';
import 'package:study/func/calendar.dart';
import 'package:get/get.dart';

import 'chat.dart';

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
          'chat': (context) =>  Chat(appbarTitle: '',),
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

      return _buildList(context, snapshot, study);
    },
  );
}

Widget _buildList(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot, String study) {
  FirebaseAuth auth = FirebaseAuth.instance;

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
              const SizedBox(height: 90),
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
                      if('학부생'+ snapshot.data!["hostName"] == auth.currentUser?.displayName.toString()){
                        FirebaseFirestore.instance.collection('study').doc(study).delete();
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