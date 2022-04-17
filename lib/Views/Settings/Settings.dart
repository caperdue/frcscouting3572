import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Views/Settings/Subviews/EventSettings.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import '../../Network/Auth.dart';

class Settings extends StatefulWidget {
  final User user;
  Settings({required this.user});

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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EventSettings(user: widget.user);
              }));
            },
            child: Text('Change Season/Event'),
          ),
          ElevatedButton(
            onPressed: () {
              auth.signOut().then((success) {
                Navigator.pushReplacementNamed(context, '/');
              }).catchError((error) {
                DialogMessage(
                    title: "Error",
                    content: "There was an error signing out: $error");
              });
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
