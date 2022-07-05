import 'package:flutter/material.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
                    color: Color.fromARGB(255, 74, 170, 248),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft:
                        Radius.circular(30)) // <--- border radius here
                ),
              ),
            ),
            ),),
          const SizedBox(height: 390),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(30, 10, 30, 10)
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 74, 170, 248)
                  )

              ),
              onPressed: () {},
              child: Text('새로운 스터디 만들기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: current_index,
          onTap: (index) {
            setState(() {
              current_index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈'
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
          selectedItemColor: Colors.blue,
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

class Cotainer {
}