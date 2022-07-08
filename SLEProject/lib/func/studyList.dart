import 'package:flutter/material.dart';

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
  var titleList = [
    'Dentist',
    'Pharmacist',
    'School teacher',
    'IT manager',
    'Account',
    'Lawyer',
    'Hairdresser',
    'Physician',
    'Web developer',
    'Medical Secretary'
  ];

  var imageList = [
    'image/1.png',
    'image/2.png',
    'image/3.png',
    'image/4.png',
    'image/5.png',
    'image/6.png',
    'image/7.png',
    'image/8.png',
    'image/9.png',
    'image/10.png'
  ];

  var description = [
    '1.There are different types of careers you can pursue in your life. Which one will it be?',
    '2.There are different types of careers you can pursue in your life. Which one will it be?',
    '3.There are different types of careers you can pursue in your life. Which one will it be?',
    '4.There are different types of careers you can pursue in your life. Which one will it be?',
    '5.There are different types of careers you can pursue in your life. Which one will it be?',
    '6.There are different types of careers you can pursue in your life. Which one will it be?',
    '7.There are different types of careers you can pursue in your life. Which one will it be?',
    '8.There are different types of careers you can pursue in your life. Which one will it be?',
    '9.There are different types of careers you can pursue in your life. Which one will it be?',
    '10.There are different types of careers you can pursue in your life. Which one will it be?'
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
        .width * 0.6;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(titleList));
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: Text('스터디 검색'),
      ),
      body: ListView.builder(
        itemCount: titleList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              debugPrint(titleList[index]);
              showPopup(context, titleList[index], imageList[index],
                  description[index]);
            },
            child: Card(
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(imageList[index]),
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
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width,
                          child: Text(
                            description[index],
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[500]),
                          ),
                        ),

                      ], //children

                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
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


  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: (){
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
