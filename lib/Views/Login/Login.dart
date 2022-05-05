import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Views/TabScreen.dart';
import '../../Network/Auth.dart';
import 'TeamSignup.dart';

class Login extends StatefulWidget {
  User? user;
  Login({required this.user});

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController rotationController;
  bool showTeamOptions = false;

  @override
  void initState() {
    super.initState();
  }

  showTeamSignup(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TeamSignup();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('FRC Scouting Login')),
        body: Center(
          child: ElevatedButton(
            child: Text('Sign in with Google'),
            onPressed: () {
              signInWithGoogle().then((result) async {
                 dynamic response =
                 await apiHelper.get("Users/${auth.currentUser!.uid}");
                 widget.user = User.fromJson(response);
                if (widget.user != null) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return TabScreen(user: widget.user!);
                  }));
                } else {
                  setState(() {
                    showTeamSignup(context);
                  });
                }
              });
            },
          ),
        ));
  }
}
