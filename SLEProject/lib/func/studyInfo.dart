import 'package:flutter/material.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Study Info",
      home: StudyInfo(),
    );
  }
}

class StudyInfo extends StatefulWidget {
  @override
  _StudyInfo createState() => _StudyInfo();
}

class _StudyInfo extends State<StudyInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Home()));},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Edit()));
            },
          ),
        ],
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
                    child: const Text(
                        '스터디명 Firebase에서 가져올 거에요',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    )),
                const SizedBox(height: 40),
                Text('방장', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)
                ),

                const SizedBox(height: 10),
                Text('전산전자공학부 김예인', style: TextStyle(fontSize: 16, color: Colors.black)
                ),
                const SizedBox(height: 30),
                Text('카카오톡 오픈채팅방 링크', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)
                ),
                const SizedBox(height: 10),
                Text('firebase에서 가져올 거예요', style: TextStyle(fontSize: 16, color: Colors.black)
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: '스터디 설명',
                  text: '스터디 설명',
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
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
                    text: '스터디 설명을 엄청 길게 써볼 거다 왜냐면 박스 크기 조절이 가능한지 볼 거니까 얼마나 써봐야 할까 근데 onChanged() 속성 없앴는데 왜 자꾸 edit 가능하게 바뀌는 거야 왜이래 왜 왜오 ㅐ왜왜 왜 왜 왜 왱',
                    style: TextStyle(fontSize: 16, color: Colors.grey)
              )))

            ],
          )
      ),
    ],
  );
}