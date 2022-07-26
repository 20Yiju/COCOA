import 'package:flutter/material.dart';
import 'package:study/func/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study/func/profile.dart';
import 'package:study/func/studyList.dart';
late List<dynamic> studies = <dynamic>[];
late List<dynamic> number = <dynamic>[];
late List<dynamic> description = <dynamic>[];
late List<dynamic> url = <dynamic>[];
late List<dynamic> userHeart = <dynamic>[];
late List<dynamic> studyHeart = <dynamic>[];
late List<dynamic> contained = <dynamic>[]; // true false
late List<dynamic> idx = <dynamic>[]; // userHeart와 studyHeart 겹치는 index
var imageList = [
  'image/o.jpeg'
];

void main() {
  runApp(const HeartList());
}

class HeartList extends StatelessWidget {
  const HeartList({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody2(context),
    );
  }
}

Widget _buildBody2(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.displayName.toString()).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildBody(context, snapshot);
    },
  );
}

Widget _buildBody(BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
  FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('study').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data!.docs, userSnapshot);
    },
  );
}


Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
  var user = FirebaseAuth.instance.authStateChanges();
  FirebaseAuth auth = FirebaseAuth.instance;

  snapshot.forEach((element) {
    if(!studies.contains(element["studyName"])) {
      studies.add(element["studyName"]);
      number.add(element["number"]);
      description.add(element["description"]);
      url.add(element["url"]);
    }
  });

  userSnapshot.data!["heart"].forEach((element) {
    print("element: $element");
    for(int i=0; i<studies.length; i++) {
      if(studies[i].compareTo(element)==0) {
        if(!userHeart.contains(studies[i])) {
          userHeart.add(element);
        }
      }
    }
  });

  print("userHeart: $userHeart");

  idx = findIndex(context, studies, userHeart);
  print("index: $idx");

  print("studylist: $studies");

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
  final List<Widget> _children = [Home(), StudyList(),HeartList(), SettingsUI()];


  print("length: ${studies.length}");
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
                  showSearch(context: context, delegate: Search(userHeart));
                },
                icon: Icon(Icons.search, color: Color(0xff485ed9)),
              )
          ),
        ],

        centerTitle: true,
        title: Text('찜 스터디 목록',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: idx.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              debugPrint(studies[index]);
              showPopup(context, userHeart[index], description[idx[index]].toString());
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
                          userHeart[index],
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
                            number[idx[index]],
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
                            contained[index]? Icons.favorite : Icons.favorite_border,
                            color: contained[index] ? Colors.red : null,
                            semanticLabel: contained[index] ? 'Remove from saved' : 'Save',),
                          onPressed: () {
                            contained.removeAt(index);

                            final heartCollectionReference = FirebaseFirestore.instance.collection(
                                "users").doc(auth.currentUser!.displayName.toString());
                            String sName = userHeart[index];
                            heartCollectionReference.update(
                                {'heart': FieldValue.arrayRemove([sName])});
                            userHeart.removeAt(index);

                          },
                        ),
                        SizedBox(
                          height: 20,
                          width: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString());
                              userCollectionReference.update({
                                'study' : FieldValue.arrayUnion([userHeart[index]])});
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder( //to set border radius to button
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              primary: Color.fromARGB(200,234,254,224),
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
    int index = userHeart.indexOf(selectedResult);
    FirebaseAuth auth = FirebaseAuth.instance;
    print('🥰🥰🥰🥰🥰🥰🥰🥰🥰');
    print(index);
    return ListView(
      children: <Widget>[
        InkWell(
          onTap: () {
            debugPrint(userHeart[index]);
            // showPopup(context, studies[index], description[index].toString());
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
                        userHeart[index],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.55,
                        child: Text(
                          number[idx[index]],
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
                            contained[index]? Icons.favorite : Icons.favorite_border,
                            color: contained[index] ? Colors.red : null,
                            semanticLabel: contained[index] ? 'Remove from saved' : 'Save',),
                          onPressed: () {
                            contained.removeAt(index);
                            // firebase update
                            final heartCollectionReference = FirebaseFirestore.instance.collection(
                                "users").doc(auth.currentUser!.displayName.toString());
                            String sName = userHeart[index];
                            heartCollectionReference.update(
                                {'heart': FieldValue.arrayRemove([sName])});
                            userHeart.removeAt(index);
                          },
                        ),
                        // SizedBox(
                        //   height: 20,
                        //   width: 50,
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString());
                            userCollectionReference.update({
                              'study' : FieldValue.arrayUnion([userHeart[index]])});
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder( //to set border radius to button
                                borderRadius: BorderRadius.circular(30)
                            ),
                            primary: Color.fromARGB(200,234,254,224),
                            onPrimary:Colors.green,
                          ),
                          child: const Text(
                            '신청',
                            style: TextStyle(fontSize: 9),
                          ),
                        ),


                    ]
                )
              ],
            ),
          ),
        ),

      ],
    );
  }

  final List<dynamic> listExample;
  Search(this.listExample);

  List<dynamic> recentList = [""];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestionList = [];
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


List<dynamic> saveUserHeart(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot, List<dynamic> studie) {
  List<dynamic> userHeart = <dynamic>[];
  snapshot.data!["heart"].forEach((element) {
    if(studies.contains(element)==0) {;
    userHeart.add(element["heart"]);
    print('아아아아아악');
    print(userHeart);
    }
  });
  return userHeart;
}

List<dynamic> findIndex(BuildContext context, List<dynamic> studies, List<dynamic> userHeart) {
  List<dynamic> index = <dynamic>[];
  for(int i=0; i<studies.length; i++) {
    if (userHeart.contains(studies[i])) {
      contained.add(true);
      index.add(i);
    }
  }
  return index;

}

