import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study/func/home.dart';
import 'package:study/func/heartList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study/func/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListViewPage(),
    );
  }
}

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  var user = FirebaseAuth.instance.authStateChanges();
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> saved = [];

  List<String> titleList = [];

  late var studies = [];
  late var number = [];
  late var description = [];
  late var url = [];
  late var heart = [];


  var imageList = [
    'image/o.jpeg'
  ];

  get trailing => null;




  void showPopup(context, title,explain) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          content: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child :SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        explain.toString(), // description[index].toString()
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인',
                        style: TextStyle( color: Colors.blue),),
                    ),
                  ],
                ),
              )

          ),
        );
      },
    );
  }

  int current_index =0;
  final List<Widget> _children = [Home(), MyApp(),HeartList(), SettingsUI()];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('study')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(!studies.contains(doc["studyName"]))  {
          studies.add(doc["studyName"]);
          number.add(doc["number"]);
          description.add(doc["description"]);
          url.add(doc["url"]);
          heart.add(doc["heart"]);
        }

      });
    });


    double width = MediaQuery
        .of(context)
        .size
        .width * 0.55;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0,0,0,0),
                child: IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: Search(titleList));
                  },
                  icon: Icon(Icons.search, color: Color(0xff485ed9)),
                )
            ),
          ],

          centerTitle: true,
          title: Text('스터디 검색',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: studies.length,
          itemBuilder: (context, index) {
            // final alreadySaved = saved.contains(studies[index]);
            final currentStudy = FirebaseFirestore.instance.collection("study").doc(studies[index]);
            return InkWell(
              onTap: () {
                debugPrint(studies[index]);
                showPopup(context, studies[index], description[index].toString());
              },
              child: Card(
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(imageList[0]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            studies[index],
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: width,
                            child: Text(
                              number[index],
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[500]),
                            ),
                          ),

                        ], //children

                      ),
                    ),
                    Column(
                        children: [
                          IconButton(
                            icon: Icon (
                              heart[index] ? Icons.favorite : Icons.favorite_border,
                              color: heart[index] ? Colors.red : null,
                              semanticLabel: heart[index] ? 'Remove from saved' : 'Save',),
                            onPressed: () {
                              setState(() {
                                if (heart[index]) {
                                  heart[index] = false;
                                  currentStudy.update({"heart" : false});
                                } else {
                                  heart[index] = true;
                                  currentStudy.update({"heart" : true});
                                }
                              });},
                          ),
                          SizedBox(
                            height: 20,
                            width: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString());
                                userCollectionReference.update({
                                  'study' : FieldValue.arrayUnion([studies[index]])});
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder( //to set border radius to button
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                primary:Color.fromARGB(200,234,254,224),
                                onPrimary:Colors.green,
                              ),
                              child: const Text(
                                '신청',
                                style: TextStyle(fontSize: 9),
                              ),

                            ),
                          )
                        ]
                    )
                  ],
                ),
              ),


            );
          },

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
                icon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search, color:Color(0xff485ed9),),
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
        )
    );
  }

}
class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  Search(this.listExample);

  List<String> recentList = [""];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
      // In the false case
          (element) => element.contains(query),
    ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          onTap: (){
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}