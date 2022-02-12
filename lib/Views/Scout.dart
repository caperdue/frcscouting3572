import 'package:flutter/material.dart';
import 'package:frcscouting3572/Network/db.dart';
import 'package:frcscouting3572/Views/TeamScoutList.dart';
import 'package:flutter/cupertino.dart';
import '../Constants.dart';

class Scout extends StatefulWidget {
  const Scout({Key? key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
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
    getMostLiked();
    //updateEventDataIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: kAquaMarine,
          width: screenWidth.width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Viewing data for GVSU Event 3/12 - 3/15",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CupertinoSearchTextField(
          controller: searchController,
          onChanged: (search) {},
        ),
        TeamScoutList(),
      ],
    );
  }
}
