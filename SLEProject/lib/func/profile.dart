import 'package:flutter/material.dart';
import 'package:study/func/editProfile.dart';
import 'package:study/func/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}
String sex = "";
String department ="";
String grade ="";


class _EditProfilePageState extends State<EditProfilePage> {
  var user = FirebaseAuth.instance.authStateChanges();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;



  bool showPassword = false;
  @override
  Widget build(BuildContext context) {



    FirebaseFirestore.instance.collection("users")
        .doc(auth.currentUser!.displayName.toString())
        .get()
        .then((DocumentSnapshot ds) {
      sex = ds["sex"];
      department = ds["department"];
      grade = ds["grade"];
    });


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
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Color(0xff485ed9),
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
          child: ListView(
            children: [
              Text(
                "Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 35,),

              buildTextField("이름", auth.currentUser!.displayName.toString(), false),
              buildTextField("성별", sex, false),
              buildTextField("학부", department, true),
              buildTextField("학년", grade, false),
              SizedBox(height: 0,),
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
                          Color(0xff485ed9)
                      ),
                    ),

                    onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SettingsUI()));},
                    child: Text('Refresh',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  )
              ),
            ],

          ),
        ),

      ),

    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        enabled: false,
      ),
    );
  }
}


/*FirebaseFirestore.instance.collection("users")
.doc(auth.currentUser!.displayName.toString())
.get()
    .then((DocumentSnapshot ds) {
department = ds["department"];
grade = ds["grade"];
sex = ds["sex"];

});*/
