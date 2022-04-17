import 'package:flutter/material.dart';
import 'package:frcscouting3572/Network/db.dart' as db;
import '../Network/Auth.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Future<bool> checkAuth() async {
    try {
      bool properlyAuthed = false;
      if (auth.currentUser != null) {
        await db.getUserInformation().then((value) { //Check for user and assigned team
          if (value.exists) {
            if (value.get('team') != null) {
              properlyAuthed = true;
            }
          }
        });
      }
      await Future.delayed(Duration(seconds: 2));
      return properlyAuthed;
    }
    catch(e) {
      print("An error has occurred!!");
    }
    return false;
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
