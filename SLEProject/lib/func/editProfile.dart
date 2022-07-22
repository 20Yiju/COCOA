import 'package:flutter/material.dart';
import 'package:study/func/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//void main() => runApp(const MyApp());

class Edit extends StatelessWidget {
  const Edit({Key? key}) : super(key: key);

  static const String _title = 'EDIT PROFILE PAGE';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title), backgroundColor: Color(0xff485ed9)),
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
  late String sex; late String department; late String grade;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

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
                        color: Color(0xff485ed9),
                        fontWeight: FontWeight.bold
                    )
                )),
            SizedBox(height: 10,),
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
                        sex = newValue!;
                        print(newValue);
                      },
                      items: ['여자', '남자'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'남자': '남자', '여자': '여자'}[i] ?? '선택'),
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
                        department = newValue!;
                        print(department);
                      },
                      items: ['글로벌리더십학부', '국제어문학부', '경영경제학부', '법학부', '커뮤니케이션학부', '상담복지학부', '생명과학공학부', '공간환경시스템공학부', '전산전자공학부', '콘텐츠융합디자인학부', '기계제어공학부', 'ICT 창업학부'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'글로벌리더십학부': '글로벌리더십학부', '국제어문학부': '국제어문학부', '경영경제학부': '경영경제학부', '법학부': '법학부', '커뮤니케이션학부': '커뮤니케이션학부', '상담복지학부': '상담복지학부', '생명과학공학부': '생명과학공학부', '공간환경시스템공학부': '공간환경시스템공학부', '전산전자공학부': '전산전자공학부', '콘텐츠융합디자인학부': '콘텐츠융합디자인학부', '기계제어공학부': '기계제어공학부', 'ICT 창업학부': 'ICT 창업학부'}[i] ?? '선택'),
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
                        grade = newValue!;
                        print(grade);
                      },
                      items: ['1학년', '2학년', '3학년', '4학년'].map<DropdownMenuItem<String?>>((String? i) {
                        return DropdownMenuItem<String?> (
                          value: i,
                          child: Text({'1학년': '1학년', '2학년': '2학년', '3학년': '3학년', '4학년': '4학년'}[i] ?? '선택'),
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
                style: ElevatedButton.styleFrom(primary: Color(0xff485ed9)),
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsUI()));
                final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(auth.currentUser!.displayName.toString());
                userCollectionReference.update({
                  'sex': sex,
                  'grade': grade,
                  'department': department
                }
                );},
              ),
            ),
          ],
        ));
  }
}