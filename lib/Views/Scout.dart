import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/db.dart' as db;
import 'package:frcscouting3572/Network/firstAPI.dart';
import 'package:frcscouting3572/Views/TeamScoutList.dart';
import 'package:flutter/cupertino.dart';
import '../Constants.dart';

class Scout extends StatefulWidget {
  const Scout({Key? key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  dynamic user;
  List<String> sortTeams = [
    'Newest to Oldest',
    'Oldest to Newest',
    'Most Liked',
    'Least Liked'
  ];
  TextEditingController searchController = TextEditingController();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Column(children: <Widget>[
      CupertinoSearchTextField(
        controller: searchController,
        onChanged: (search) {
          
        },
      ),
      TeamScoutList(),
    ]);
  }
}
