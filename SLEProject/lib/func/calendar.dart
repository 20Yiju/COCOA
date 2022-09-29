import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/func/calendar/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:study/func/studyInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study/func/home.dart';
import 'chat.dart';

late Map<DateTime, List<Event>> selectedEvents = {};
late Map<String, List<String>> userName = {};
late Map<String, int> memberComplete = {};


String? date; String? event;
int complete = 0;
int totalNum = 0;

class Calendar extends StatelessWidget {
  final String appbarTitle;
  const Calendar({Key? key, required this.appbarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Calendar2(appbarTitle: appbarTitle,),
    );
  }
}

class Calendar2 extends StatefulWidget {
  @override

  final String appbarTitle;
  Calendar2({Key ?key, required this.appbarTitle}) : super(key: key);
  State<Calendar2> createState() => _CalendarState();

}

Widget _buildBody2(BuildContext context, String study) {
  FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.displayName.toString()).collection("achievement").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildBody(context, study, snapshot.data!.docs);
    },
  );
}

Widget _buildBody(BuildContext context, String study, List<DocumentSnapshot> userSnapshot) {
  userSnapshot.forEach((element) {
    if(study.compareTo(element["studyName"])==0) {
      complete = element["개인별"];
    }
  });
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("study").doc(study).collection("calendar").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      else {
        snapshot.data!.docs.forEach((element) {
          if(element["date"].compareTo("일정개수") == 0) {
            totalNum = element["개수"];
            print("개수: $totalNum");
          }
          else if(element["date"].compareTo("멤버별성취도") == 0) {
            for(String m in element["member"]) {
              memberComplete[m] = element[m]["완료개수"];
            }
          }
          else {
            if (!selectedEvents.containsKey(DateTime.parse(element["date"]))) {

              for(String s in element["todo"]) {
                if (selectedEvents[DateTime.parse(element["date"])] != null) {
                  if(s!=null) {
                    selectedEvents[DateTime.parse(element["date"])]?.add(
                      Event(title: s),
                    );
                  }
                } else {
                  if(s!=null) {
                    selectedEvents[DateTime.parse(element["date"])] = [
                      Event(title: s),
                    ];
                  }
                }
                int index = 0;
                for(String str in element[s]) { // str이 유저네임..
                  index++;
                  if (userName[(element["date"]+s)] != null) {
                    if(str != null) {
                      userName[(element["date"]+s)]?.add(
                        str,
                      );
                    }
                  } else {
                    if(str != null) {
                      userName[(element["date"]+s)] = [
                        str,
                      ];
                    }
                  }
                }
              }
            }
          }
        });
      }
      return Text('');
    },
  );
}


class _CalendarState extends State<Calendar2> {
  int current_index = 1;
  final List<Widget> _children = [Info(),Calendar(appbarTitle:''),Chat(appbarTitle: '')];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _ischecked = false;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
    _buildBody2(context,widget.appbarTitle);
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.appbarTitle} 스터디 일정",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
            )),
        centerTitle: true,
        backgroundColor: Color(0xff485ed9),
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.Info, arguments: {"study": widget.appbarTitle});
            }
        ),
      ),

      body: Scaffold( body: LayoutBuilder(builder: (ctx, constrains) {
        return Scaffold(body: Container(
          height: constrains.maxHeight,
          child: SizedBox(
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBody2(context, widget.appbarTitle),
                  TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //Day Changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });

                      date = focusedDay.toString();

                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },

                    eventLoader: _getEventsfromDay,

                    //To style the Calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Color(0xff485ed9),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Color(0xff485ed9),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ..._getEventsfromDay(selectedDay).map(
                        (Event event) {
                      if(userName.containsKey(selectedDay.toString()+(event.title))) {
                        if(userName[selectedDay.toString()+(event.title)] != null) {
                          if(userName[selectedDay.toString()+(event.title)]?.contains(auth.currentUser!.displayName.toString()) == true) {
                            _ischecked = true;
                          } else _ischecked = false;

                        }
                      }

                      return ListTile(
                        title: Text(event.title,),
                        trailing: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.redAccent,
                          value: _ischecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _ischecked = value!;
                              final completeUserReference = FirebaseFirestore
                                  .instance.collection("study").doc(
                                  widget.appbarTitle)
                                  .collection("calendar")
                                  .doc('$selectedDay');
                              final achievementCollectionReference = FirebaseFirestore
                                  .instance.collection('users').doc(auth.currentUser!.displayName.toString()).collection("achievement").doc(widget.appbarTitle);
                              final memberAchieveReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc("멤버별성취도");

                              if (_ischecked) { // 사용자가 완료 체크를 했을 때
                                complete++;
                                completeUserReference.update({
                                  event.title: FieldValue.arrayUnion([
                                    auth.currentUser!.displayName.toString()
                                  ])
                                });
                                print("🥰🥰🥰🥰🥰🥰🥰🥰🥰🥰Complete: $complete");
                                userName[selectedDay.toString()+(event.title)]?.add(auth.currentUser!.displayName.toString());
                                achievementCollectionReference.update({
                                  '개인별': complete,
                                  '성취도': ((complete/totalNum)*100).floor()
                                });
                                memberAchieveReference.update({auth.currentUser!.displayName.toString(): {
                                  '완료개수': complete,
                                  '성취도': ((complete / totalNum) * 100).floor()
                                }});

                              } else { // 사용자가 완료 체크를 해제했을 때
                                complete--;
                                completeUserReference.update({
                                  event.title: FieldValue.arrayRemove([
                                    auth.currentUser!.displayName.toString()
                                  ])
                                });
                                print("🥰🥰🥰🥰🥰🥰🥰🥰🥰🥰Complete: $complete");
                                userName[selectedDay.toString()+(event.title)]?.remove(auth.currentUser!.displayName.toString());
                                achievementCollectionReference.update({
                                  '개인별': complete,
                                  '성취도': ((complete/totalNum)*100).floor()
                                });
                                memberAchieveReference.update({auth.currentUser!.displayName.toString(): {
                                  '완료개수': complete,
                                  '성취도': ((complete / totalNum) * 100).floor()
                                }});
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
      })),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("일정 등록하기"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () {

                  if (_eventController.text.isEmpty) {

                  } else {
                    final calendarCollectionReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc(date);
                    final totalNumCollectionReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc("일정개수");
                    final achievementCollectionReference = FirebaseFirestore
                        .instance.collection('users').doc(auth.currentUser!.displayName.toString()).collection("achievement").doc(widget.appbarTitle);
                    final memberAchieveReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc("멤버별성취도");

                    totalNum++;
                    userName[(selectedDay.toString()+_eventController.text)] = [
                      "null",
                    ];
                    if (selectedEvents[selectedDay] != null) {

                      selectedEvents[selectedDay]?.add(
                        Event(title: _eventController.text),
                      );
                      event = _eventController.text;
                      calendarCollectionReference.update({'todo': FieldValue.arrayUnion([event]), 'date': date, '$event': FieldValue.arrayUnion(["null"])});
                      totalNumCollectionReference.update({'개수': totalNum});
                      achievementCollectionReference.update({"성취도": ((complete/totalNum)*100).floor()});

                      for(String memberName in memberComplete.keys) {
                        memberAchieveReference.update({memberName : {
                          '완료개수': memberComplete[memberName],
                          '성취도': ((memberComplete[memberName]! / totalNum) * 100).floor()
                        }});
                      }

                    } else {
                      event = _eventController.text;
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                      calendarCollectionReference.set({'todo': FieldValue.arrayUnion([event]), 'date': date, '$event': FieldValue.arrayUnion(["null"])});
                      totalNumCollectionReference.update({'개수': totalNum});
                      achievementCollectionReference.update({"성취도": ((complete/totalNum)*100).floor()});

                      for(String memberName in memberComplete.keys) {
                        memberAchieveReference.update({memberName : {
                          '완료개수': memberComplete[memberName],
                          '성취도': ((memberComplete[memberName]! / totalNum) * 100).floor()
                        }});
                      }


                    }
                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  setState((){});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("일정 등록하기"),
        icon: Icon(Icons.add),
        backgroundColor:  Color(0xff485ed9),
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
              icon: Icon(Icons.widgets),
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
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),

    );
  }
}
