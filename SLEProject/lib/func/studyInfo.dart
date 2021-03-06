import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';
import 'package:study/func/calendar.dart';
import 'package:get/get.dart';

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
      print("study: " + study);
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
              Text('??????', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),

              const SizedBox(height: 10),
              Text(snapshot.data!["hostName"], style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              const SizedBox(height: 30),
              Text("???????????? ??????????????? ??????", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),
              const SizedBox(height: 10),
              Text(snapshot.data!["url"], style: TextStyle(fontSize: 16, color: Colors.black)
              ),
              const SizedBox(height: 30),
              Text('????????? ?????????', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
              ),
              const SizedBox(height: 90),
              TextFieldWidget(
                label: '????????? ??????',
                text: snapshot.data!["description"],
                maxLines: 10,
              ),
              const SizedBox(height: 15),
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
                        //Color.fromARGB(255, 74, 170, 248)
                          Color(0xff485ed9)
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Calendar(appbarTitle : study)));
                      // );
                    },
                    child: Text('?????? ???????????? ??????',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  )
              ),
            ],
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