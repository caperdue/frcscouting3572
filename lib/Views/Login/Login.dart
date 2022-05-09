import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Views/TabScreen.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Login/TeamSignup.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login();

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
     final UserBloc userBloc = Provider.of<UserBloc>(context);
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
                 userBloc.user = User.fromJson(response);
                if (userBloc.user.team != 0) { // No team can have 0
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return TabScreen();
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
