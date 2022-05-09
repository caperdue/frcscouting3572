import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/TeamScoutList.dart';
import 'package:flutter/cupertino.dart';
import 'package:frcscouting3572/Views/Shared/EventSeasonBanner.dart';

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
    
    return Column(children: <Widget>[
      EventSeasonBanner(),
      CupertinoSearchTextField(
        controller: searchController,
        onChanged: (search) {
          setState(() {});
        },
      ),
      TeamScoutList(
        searchText: searchController.text
      ),
    ]);
  }
}
