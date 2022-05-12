import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/blocs/QueryBloc.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/TeamScoutList.dart';
import 'package:flutter/cupertino.dart';
import 'package:frcscouting3572/Views/Shared/EventSeasonBanner.dart';
import 'package:provider/provider.dart';

class Scout extends StatefulWidget {
  Scout();

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
    QueryBloc queryBloc = Provider.of<QueryBloc>(context);
    return Column( 
      children: <Widget>[
      EventSeasonBanner(),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CupertinoSearchTextField(
                controller: searchController,
                onChanged: (text) {
                  queryBloc.searchText = text;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            )
          ],
        ),
      ),
      TeamScoutList(),
    ]);
  }
}
