import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study/func/home.dart';


class AddStudy extends StatelessWidget {
  const AddStudy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Suit',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AddStatefulWidget(),
    );
  }
}

class AddStatefulWidget extends StatefulWidget {
  const AddStatefulWidget({Key? key}) : super (key: key);

  @override
  State<AddStatefulWidget> createState() => AddStateWidget();
}

class AddStateWidget extends State<AddStatefulWidget> {
  late String name, number, description, url;
  FirebaseAuth auth = FirebaseAuth.instance;
  final inputController1 = TextEditingController();
  final inputController2 = TextEditingController();
  final inputController3 = TextEditingController();
  final inputController4 = TextEditingController();
  final inputController5 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('새로운 스터디 등록'),
          leading:  IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Home())); //뒤로가기
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Color(0xff485ed9),
        ),
        body: Center(
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '스터디 이름',
                        ),
                        onChanged: (String? newValue) {
                          name = newValue!;
                          print(name);
                        },
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        controller: inputController1
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '방장 이름',
                          ),
                          onChanged: (String? newValue) {
                            name = newValue!;
                            print(name);
                          },
                          validator: (value) {
                            if(value!.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                          controller: inputController5
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '인원',
                        ),
                        onChanged: (String? newValue) {
                          number = newValue!;
                          print(number);
                        },
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        controller: inputController2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '스터디 설명',
                        ),
                        onChanged: (String? newValue) {
                          description = newValue!;
                          print(description);
                        },
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                          controller: inputController3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '오픈채팅방 주소',
                        ),
                        onChanged: (String? newValue) {
                          url = newValue!;
                          print(url);
                        },
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                          controller: inputController4,
                      ),
                    ),
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
                            final userCollectionReference = FirebaseFirestore
                                .instance.collection("users").doc(
                                auth.currentUser!.displayName.toString());
                            userCollectionReference.update({
                              'study': FieldValue.arrayUnion(
                                  [name])});

                            // final studyCollectionReference = FirebaseFirestore
                            //     .instance.collection("study").doc(
                            //     inputController1.text);
                            // studyCollectionReference.update({
                            //   'member': 1 });
                            // print("member count: ${member[index]}");

                            final studyCollectionReference = FirebaseFirestore.instance.collection("study").doc(inputController1.text);
                            studyCollectionReference.set({
                              "studyName": inputController1.text,
                              "number": inputController2.text,
                              "description": inputController3.text,
                              "url": inputController4.text,
                              "heart": false,
                              "hostName": inputController5.text,
                              "member": 1,
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Home()));
                          },
                          child: Text('등록',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                        )
                    ),
                    SizedBox(height: 20,),

                  ]
              )
            )
          )
        )

    );
  }
}