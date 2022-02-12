import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Views/TeamCreation/ViewTeam.dart';
import 'Shared/TeamCard.dart';

import '../Network/firstAPI.dart' as firstAPI;

class TeamScoutList extends StatefulWidget {
  const TeamScoutList({Key? key}) : super(key: key);

  @override
  _TeamScoutListState createState() => _TeamScoutListState();
}

class _TeamScoutListState extends State<TeamScoutList> {
  late Stream<QuerySnapshot> teamStream;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: firstAPI.getTeamsAtEvent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewTeam(team: data[index]["teamNumber"], newTeam: false, uid: null, nickname: data[index]["nameShort"],)));
                      },
                      child: TeamCard(
                          number: data[index]["teamNumber"],
                          liked: 1,
                          nickname: data[index]["nameShort"]),
                    );
                  });
            }
            return Center(child: Column(
              children: [
                CircularProgressIndicator(),
              ],
            ));
          }),
    );
  }
}
