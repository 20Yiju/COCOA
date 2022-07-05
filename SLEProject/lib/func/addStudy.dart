import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('새로운 스터디 등록'),
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '스터디 이름',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '인원',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '스터디 설명',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '오픈채팅방 주소',
                        ),
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
                                Color.fromARGB(255, 74, 170, 248)
                            ),
                          ),

                          onPressed: () {},
                          child: Text('새로운 스터디 만들기',
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