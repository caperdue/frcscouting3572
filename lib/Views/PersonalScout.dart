import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Views/TeamCreation/ViewTeam.dart';
import 'Shared/TeamCard.dart';
import '../Constants.dart';

import '../Network/db.dart' as db;

class PersonalScout extends StatefulWidget {
  const PersonalScout({Key? key}) : super(key: key);

  @override
  _PersonalScoutState createState() => _PersonalScoutState();
}

class _PersonalScoutState extends State<PersonalScout> {
  late Stream<QuerySnapshot> teamStream;
  List<dynamic> filteredTeams = <int>[];
  @override
  void initState() {
    super.initState();
    teamStream = db.user.collection('ScoutData').snapshots();
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: teamStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final teams = snapshot.data!.docs;
            //Convert stream of data into widgets
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    int teamNum = teams[index]['number'];
                    final scoutTeam =
                        db.grabTeam(teamNum).then((teamSnapshot) {
                      if (teamSnapshot.exists) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewTeam(
                                    team: teamNum, newTeam: false)));
                      }
                    });
                  },
                  child: Dismissible(
                    key: UniqueKey(), // Prevent error from unique widget
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      db.deleteTeam(teams[index]['number']).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text('Team successfully deleted')));
                      });
                    },
                    child: TeamCard(
                        number: teams[index]['number'],
                        liked: teams[index]['likeStatus']),
                    background: Container(color: kRed),
                  ),
                );
              },
            );
          }),
    );
  }
}
