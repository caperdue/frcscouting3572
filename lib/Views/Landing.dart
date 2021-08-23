import 'package:flutter/material.dart';
import '../Network/Auth.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Future<bool> checkAuth() async {
    await Future.delayed(Duration(seconds: 2));
    return auth.currentUser != null ? true : false;
  }

  @override
  void initState() {
    super.initState();
    checkAuth().then((signedIn) {
      if (signedIn) {
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
