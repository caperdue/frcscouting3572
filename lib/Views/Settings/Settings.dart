import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Network/Auth.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/eventSettings");
            },
            child: Text('Change Season/Event'),
          ),
          ElevatedButton(
            onPressed: () {
              auth.signOut().then((value) {
                GoogleSignIn().signOut().then((success) {
                  Navigator.pushReplacementNamed(context, '/');
                }).catchError((error) {
                  print('There was an error signing out!');
                  Navigator.pushReplacementNamed(context, '/');
                });
              });
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
