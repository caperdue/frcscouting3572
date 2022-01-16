import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Network/Auth.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: ElevatedButton(onPressed: () {
      auth.signOut().then((value) {
        GoogleSignIn().signOut().then((success) {
          Navigator.pushReplacementNamed(context, '/');
        }).catchError((error) {
          print('There was an error signing out!');
          Navigator.pushReplacementNamed(context, '/');
        });
      });

    },
      child: Text('Sign out'),));
  }
}
