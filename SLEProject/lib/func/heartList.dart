import 'package:flutter/material.dart';
import 'package:study/func/home.dart';

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
  List<String> saved = [];

  var titleList = [
    '데구 스터디',
    '자바 스터디',
    '알고리즘 스터디',
    '토익 스터디',
    'OS 스터디',
    '몰라',
    '백준 스터디',
    '몰라',
    '몰라!!!',
    '몰라!!!!!'
  ];

  var imageList = [
    'image/o.jpeg'
  ];

  var description = [
    '여기에 인원수 가져와야할 걸 ,,?'
  ];

  get trailing => null;




  void showPopup(context, title, image, description) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.7,
            height: 380,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    description,
                    maxLines: 3,
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width * 0.55;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.blueGrey,
          ),
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Home()));},
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0,0,40,0),
              child: IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: Search(titleList));
                },
                icon: Icon(Icons.search, color: Colors.black),
              )
          )
        ],
        centerTitle: true,
        title: Text('찜 리스트 검색',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: titleList.length,
        itemBuilder: (context, index) {
          final alreadySaved = saved.contains(titleList[index]);
          return InkWell(
            onTap: () {
              debugPrint(titleList[index]);
              showPopup(context, titleList[index], imageList[0],
                  description[0]);
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
                          titleList[index],
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
                            description[0],
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
                            alreadySaved ? Icons.favorite : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',),
                          onPressed: () {
                            setState(() {
                              if (alreadySaved) {
                                saved.remove(titleList[index]);
                              } else {
                                saved.add(titleList[index]);
                              }
                            });},
                        ),
                        SizedBox(
                          height: 20,
                          width: 50,
                          child: ElevatedButton(
                            onPressed: () {},
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