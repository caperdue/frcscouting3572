import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Shared/TeamCard.dart';
import 'package:frcscouting3572/Views/TeamCreation/ViewTeam.dart';

import '../Network/firstAPI.dart' as firstAPI;
import '../Network/db.dart' as db;

class TeamScoutList extends StatefulWidget {
  const TeamScoutList({Key? key}) : super(key: key);

  @override
  _TeamScoutListState createState() => _TeamScoutListState();
}

class _TeamScoutListState extends State<TeamScoutList> {
  late Stream<QuerySnapshot> teamStream;
  dynamic scoutedTeams = [];

  @override
  void initState() {
    super.initState();
    listenForScoutDataChanges();
  }

  // TODO: THIS doesn't always work properly. Doesn't say I liked it
  // Listen for document changes and trigger a rebuild if necessary.
  void listenForScoutDataChanges() {
    db.getScoutDataByEvent().then((Query? scoutDataQuery) {
      scoutDataQuery
          ?.snapshots()
          .listen((QuerySnapshot<Object?> scoutTeamSnapshots) {
        setState(() {});
      });
    });
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: db.user.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userDoc = snapshot.data as DocumentSnapshot;
              User user = User.fromJson(userDoc.data() as Map<String, dynamic>);
              return FutureBuilder(
                  future: firstAPI.getTeamsAtEvent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic teams = snapshot.data;
                      return FutureBuilder(
                          future: db.getUserTeamAndSeasonScoutData(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemCount: teams.length,
                                itemBuilder: (context, index) {
                                  final registeredTeam = teams[index];
                                  int teamNumber = registeredTeam["teamNumber"];
                                  ScoutTeam scoutTeam = ScoutTeam(
                                      number: teamNumber,
                                      likeStatus: 1,
                                      comments: "",
                                      images: null,
                                      stats: null,
                                      createdBy: auth.currentUser!.uid,
                                      eventCode: user.eventCode!,
                                      season: user.season,
                                      assignedTeam: user.team!);
                                  String? scoutDataUID;
                                  if (snapshot.hasData) {
                                    Map<int, dynamic> dbTeams = snapshot.data
                                        as Map<int,
                                            QueryDocumentSnapshot<Object?>>;
                                    var doc =
                                        dbTeams[teams[index]["teamNumber"]];
                                    if (doc != null) {
                                      QueryDocumentSnapshot<Object?>
                                          scoutDataSnapshot =
                                          doc as QueryDocumentSnapshot<Object?>;
                                      Map<String, dynamic> scoutDataJSON =
                                          scoutDataSnapshot.data()
                                              as Map<String, dynamic>;
                                      ScoutTeam existingScoutData =
                                          ScoutTeam.fromJson(scoutDataJSON);
                                      scoutTeam = existingScoutData;
                                      scoutDataUID = scoutDataSnapshot.id;
                                    }
                                  }
                                  return FutureBuilder(
                                      future:
                                          db.getTotalLikesDislikes(teamNumber),
                                      builder: (context, snapshot) {
                                        Map<String, int>? likesDislikes =
                                            snapshot.data as Map<String, int>?;
                                        int? likes = likesDislikes?["likes"];
                                        int? dislikes =
                                            likesDislikes?["dislikes"];
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ViewTeam(
                                                          scoutTeam: scoutTeam,
                                                          additionalTeamInfo: {"School": registeredTeam["schoolName"],
                                                          "Rookie Year": registeredTeam["rookieYear"], 
                                                          "City": registeredTeam["city"],
                                                          "State": registeredTeam["stateProv"],
                                                          "Website": registeredTeam["website"]},
                                                          
                                                          uid: scoutDataUID)));
                                            },
                                            child: TeamCard(
                                              scoutTeam: scoutTeam,
                                              nickname:
                                                  registeredTeam['nameShort'],
                                              numLikes:
                                                  likes != null ? likes : 0,
                                              numDislikes: dislikes != null
                                                  ? dislikes
                                                  : 0,
                                            ));
                                      });
                                });
                          });
                    }

                    return Center(
                      child: Text(
                        "Go to Settings to select an event, you currently do not have one selected!",
                        textAlign: TextAlign.center,
                      ),
                    );
                  });
            }
            return Text("Error retrieving user info");
          }),
    );
  }
}
