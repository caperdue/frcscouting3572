import 'package:flutter/material.dart';
import '../Network/Auth.dart';
import '../Network/db.dart';
import 'Shared/DialogMessage.dart';
import 'Shared/LoginForm.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController rotationController;
  bool showTeamOptions = false;

  @override
  void initState() {
    super.initState();
    listenAuthChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('FRC Scouting Login')),
      body: Center (
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () {
            signInWithGoogle().then((signedIn) {
              user.get().then((value) {
                if (value.get('team') != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  setState(() {
                    showLoginForm(context);
                  });
                }
              });
            }).catchError((error) {
              showDialogMessage(context, 'Error', error.toString());
            });
          },
        ),

      )
    );
  }
}
