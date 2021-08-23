import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Network/Auth.dart';
import '../../Shared/DialogMessage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
    listenAuthChanges();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FRC Scouting Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () {
            signInWithGoogle().then((signedIn) {
              Navigator.pushReplacementNamed(context, '/home');
            }).catchError((error) {
              print('ran');
              showDialogMessage(context, 'Error', error.toString());
            });
          },
        ),
      ),
    );
  }
}
