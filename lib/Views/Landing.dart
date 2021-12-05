import 'package:flutter/material.dart';
import 'package:frcscouting3572/Network/db.dart';
import '../Network/Auth.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Future<bool> checkAuth() async {
    bool properlyAuthed; // Needs to have a user and assigned team
    await user.get().then((value) {
      if (value.get('team') != null) {
        properlyAuthed = true;
      }
    });
    properlyAuthed = false;
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
