import 'package:flutter/material.dart';

//void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'EDIT PROFILE PAGE';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold
                    )
                )),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이름',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String?>(
                      decoration: InputDecoration(
                        labelText: '성별',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                      ),
                      onChanged: (String? newValue) {
                        print(newValue);
                      },
                      items: ['1', '2'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'1': '남자', '2': '여자'}[i] ?? '선택'),
                        );
                      }).toList(),
                    )],
                )
            ),
            SizedBox(height: 10,),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String?>(
                      decoration: InputDecoration(
                        labelText: '학부',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                      ),
                      onChanged: (String? newValue) {
                        print(newValue);
                      },
                      items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'1': '글로벌리더십학부', '2': '국제어문학부', '3': '경영경제학부', '4': '법학부', '5': '커뮤니케이션학부', '6': '상담복지학부', '7': '생명과학공학부', '8': '공간환경시스템공학부', '9': '전산전자공학부', '10': '콘텐츠융합디자인학부', '11': '기계제어공학부', '12': 'ICT 창업학부'}[i] ?? '선택'),
                        );
                      }).toList(),
                    )],
                )
            ),
            SizedBox(height: 10,),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String?>(
                      decoration: InputDecoration(
                        labelText: '학년',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                      ),
                      onChanged: (String? newValue) {
                        print(newValue);
                      },
                      items: ['1', '2', '3', '4'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'1': '1학년', '2': '2학년', '3': '3학년', '4': '4학년'}[i] ?? '선택'),
                        );
                      }).toList(),
                    )],
                )
            ),
            SizedBox(height: 35,),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Edit',
                    style: TextStyle(fontSize: 20),),

                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )
            ),
          ],
        ));
  }
}