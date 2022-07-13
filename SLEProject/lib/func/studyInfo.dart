import 'package:flutter/material.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';
import 'package:study/func/calendar/calendar.dart';

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
                    child: const Text(
                        '스터디명 Firebase에서 가져올 거에요',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    )),
                const SizedBox(height: 40),
                Text('방장', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
                ),

                const SizedBox(height: 10),
                Text('전산전자공학부 김예인', style: TextStyle(fontSize: 16, color: Colors.black)
                ),
                const SizedBox(height: 30),
                Text('카카오톡 오픈채팅방 링크', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
                ),
                const SizedBox(height: 10),
                Text('firebase에서 가져올 거예요', style: TextStyle(fontSize: 16, color: Colors.black)
                ),
                const SizedBox(height: 30),
                Text('멤버별 성취도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff485ed9))
                ),
                const SizedBox(height: 90),
                TextFieldWidget(
                  label: '스터디 설명',
                  text: '스터디 설명',
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
                             context, MaterialPageRoute(builder: (_) => Calendar()));
                      },
                      child: Text('일정 페이지로 이동',
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
                      text: '박스 크기가 조절되는지 확인하기 위해서 아무 말이나 쓰고 있습니다 사실 조절 되는 걸 확인하긴 했지만 이전 텍스트가 너무 정신없어서 리뉴얼합니다 조절 잘된다 최고!',
                      style: TextStyle(fontSize: 16, color: Colors.grey)
                  )))

            ],
          )
      ),
    ],
  );
}