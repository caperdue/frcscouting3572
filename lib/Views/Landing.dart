import 'package:flutter/material.dart';
import 'package:frcscouting3572/Network/db.dart';
import '../Network/Auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Future<bool> checkAuth() async {
    bool properlyAuthed = false;
      await user.get().then((value) { //Check for user and assigned team
          if (value.exists) {
            if (value.get('team') != null) {
              properlyAuthed = true;
            }
          }
      });
      await Future.delayed(Duration(seconds: 2));
      return properlyAuthed;
  }

  @override
  void initState() {
    super.initState();
    checkAuth().then((properlyAuthed) {
      if (properlyAuthed) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
