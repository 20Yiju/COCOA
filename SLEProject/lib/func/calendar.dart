import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/func/calendar/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:study/func/studyInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study/func/home.dart';
late Map<DateTime, List<Event>> selectedEvents = {};
// late Map<DateTime, List<bool>> completedEvents = {};

String? date; String? event;

class Calendar extends StatefulWidget {
  @override

  final String appbarTitle;
  Calendar({Key ?key, required this.appbarTitle}) : super(key: key);
  _CalendarState createState() => _CalendarState();

}

Widget _buildBody2(BuildContext context, String study) {
  FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.displayName.toString()).collection(study).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildBody(context, study, snapshot.data!.docs);
    },
  );
}

Widget _buildBody(BuildContext context, String study, List<DocumentSnapshot> userSnapshot) {
  print("buildBody 호출!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("study").doc(study).collection("calendar").snapshots(),
    builder: (context, snapshot) {
      print("스트림 빌더");
      if (!snapshot.hasData) return LinearProgressIndicator();

      else {
        snapshot.data!.docs.forEach((element) {
          print("snapshot 반복문 돌아감");
          print("element[date]: ${DateTime.parse(element["date"])}");
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
            }
          }
          print("selectedEvents $selectedEvents");
        });
      }
      return Text('');
    },
  );
}


class _CalendarState extends State<Calendar> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _ischecked = false;
  // late Map<DateTime, List<Event>> selectedEvents;
  // 맨 처음 이 페이지에 들어왔을 때 Map<DateTime, List<Event>> selectedEvent에 firebase에 있는 데이터들을 저장하는거야. 그렇게 초기화를 하는거지, 그리고
  // selectedEvent에 값이 업데이트 될 때마다 selectedEvent[dateTime]에 할 일들을 add 하잖아. 그럼 동시에 firebase에 저장하면 되지
  // 그렇다면 이렇게 할까...? late Map<DateTime, List<Event>> selectedEvents를 전역변수로...? 그리고 streambuilder로
  // 해당 스터디 snapshot을 가져오고 필드 event가 :을 contain 한다면 map에 add하는 걸로

  // StreamBuilder<DocumentSnapshot>(
  // stream: FirebaseFirestore.instance.collection('users').doc(study).snapshots(),
  // builder: (context, snapshot) {
  // if (!snapshot.hasData) return LinearProgressIndicator();
  //
  // return _buildList(context, snapshot);
  // }

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
    /*_buildBody(context,widget.appbarTitle);*/
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
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => StudyInfo()));
              Navigator.of(context).pushNamed(Routes.Info, arguments: {"study": widget.appbarTitle});
            }
        ),
      ),
      // body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      //   stream: FirebaseFirestore.instance
      //       .collection('study').doc(widget.appbarTitle)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if(snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }
      //     snapshot.data![selectedDay].forEach((element) {
      //       if (selectedEvents[selectedDay] != null) {
      //         selectedEvents[selectedDay]?.add(
      //           Event(title: element),
      //         );
      //       } else {
      //         selectedEvents[selectedDay] = [
      //           Event(title: element)
      //         ];
      //       }
      //     });
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
                      // snapshot.data![selectedDay].forEach((element) {
                      //   if (selectedEvents[selectedDay] != null) {
                      //     selectedEvents[selectedDay]?.add(
                      //       Event(title: element),
                      //     );
                      //   } else {
                      //     selectedEvents[selectedDay] = [
                      //       Event(title: element)
                      //     ];
                      //   }
                      // });
                      print(focusedDay);
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
                        (Event event) =>  CheckboxListTile(
                      title: Text(event.title,),
                      activeColor: Colors.redAccent,
                      checkColor: Colors.black,
                      selected: _ischecked,
                      value: _ischecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _ischecked = value!;
                        });
                      },
                    ),
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
                    if (selectedEvents[selectedDay] != null) {

                      selectedEvents[selectedDay]?.add(
                        Event(title: _eventController.text),
                      );
                      event = _eventController.text;
                      final calendarCollectionReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc(date);
                      calendarCollectionReference.update({'todo': FieldValue.arrayUnion([event]), 'date': date});

                    } else {
                      event = _eventController.text;
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                      final calendarCollectionReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle).collection("calendar").doc(date);
                      calendarCollectionReference.set({'todo': FieldValue.arrayUnion([event]), 'date': date});
                    }
                    //print("마지막 확인 $event 그리고 $date");
                    print('selectedDay: $selectedDay');
                    print("date: $date");
                  }

                  // final calendarReference = FirebaseFirestore.instance.collection("study").doc(widget.appbarTitle);
                  // calendarReference.update({'$date' : FieldValue.arrayUnion([event])});
                  // title : 일정 이름, selectDay
                  //print("title $title, day: $selectedDay");
                  //print("title title, day: $selectedDay");


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

    );
  }
}

/*final userStudyCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString()).collection(widget.appbarTitle).doc(date);
                      userStudyCollectionReference.update({'todo': FieldValue.arrayUnion([{'$event': false}]), 'date': date});*/

// final userStudyCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString()).collection(widget.appbarTitle).doc(date);
// userStudyCollectionReference.set({'todo': FieldValue.arrayUnion([{'$event': false}]), 'date': date});