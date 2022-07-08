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
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Builder(
            builder: (context) => Scaffold(
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: '방장',
                    text: '방장',
                    onChanged: (name) {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: '카카오톡 오픈채팅방 링크',
                    text: '링크',
                    onChanged: (email) {},
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: '스터디 설명',
                    text: '스터디 설명',
                    maxLines: 10,
                    onChanged: (about) {},
                  ),
                ],
              ),
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
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: widget.maxLines,
      ),
    ],
  );
}