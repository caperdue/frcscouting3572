import 'package:flutter/material.dart';
import '../Network/Auth.dart';
import '../Network/db.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FRC Scouting Login')
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () {
            signInWithGoogle().then((signedIn) {
              print(auth.currentUser?.uid);
              Navigator.pushReplacementNamed(context, '/home');
            }).catchError((error) {
              print('An error has occurred');
            });


          },
        ),
      ),
    );
  }
}
