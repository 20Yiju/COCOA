import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
//Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

//Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

// Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SNS Login"),
        backgroundColor: Color(0xff485ed9),
        ),
      body: Column(
        children: [
          SizedBox(height: 130,),
          Container(
            width: 250,
              height: 250,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo3.png'),
                  fit: BoxFit.fill,

                ),
              ),
          ),
          SizedBox(height: 40,),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text("Google Login", style: TextStyle(fontSize: 20),),
                onPressed: signInWithGoogle,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff485ed9)),
                  padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                ),
                ),
              ),),
        ],
      ),
    );
  }
}
