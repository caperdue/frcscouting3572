import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/TeamCard.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/ViewTeam.dart';

import '../../../Network/firstAPI.dart' as firstAPI;
import '../../../Network/db.dart' as db;

// ignore: must_be_immutable
class TeamScoutList extends StatefulWidget {
  String searchText;
  User user;
  TeamScoutList({required this.searchText, required this.user});

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

  List<dynamic> queryTeams(List<dynamic> teams) {
    List<dynamic> filteredTeams = teams.where((team) {
      String teamNumber = team["teamNumber"].toString();
      String nameShort = team["nameShort"].toLowerCase();
      String lowerCaseSearch = widget.searchText.toLowerCase();
      if (teamNumber.contains(RegExp("^$lowerCaseSearch")) ||
          nameShort.contains(RegExp("^$lowerCaseSearch"))) {
        return true;
      }
      return false;
    }).toList();

    return filteredTeams;
  }

  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
            future: firstAPI.getTeamsAtEvent(widget.user),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                dynamic teams = queryTeams(snapshot.data as List<dynamic>);
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
                                eventCode: widget.user.eventCode!,
                                season: widget.user.season,
                                assignedTeam: widget.user.team!);
                            String? scoutDataUID;
                            if (snapshot.hasData) {
                              Map<int, dynamic> dbTeams = snapshot.data
                                  as Map<int, QueryDocumentSnapshot<Object?>>;
                              var doc = dbTeams[teams[index]["teamNumber"]];
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
                                future: db.getTotalLikesDislikes(teamNumber),
                                builder: (context, snapshot) {
                                  Map<String, int>? likesDislikes =
                                      snapshot.data as Map<String, int>?;
                                  int? likes = likesDislikes?["likes"];
                                  int? dislikes = likesDislikes?["dislikes"];
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewTeam(
                                                    user: widget.user,
                                                    scoutTeam: scoutTeam,
                                                    school: registeredTeam[
                                                        "schoolName"],
                                                    rookieYear: registeredTeam[
                                                        "rookieYear"],
                                                    city:
                                                        registeredTeam["city"],
                                                    state: registeredTeam[
                                                        "stateProv"],
                                                    nickname: registeredTeam[
                                                        "nameShort"],
                                                    stats: {},
                                                    uid: scoutDataUID)));
                                      },
                                      child: TeamCard(
                                        scoutTeam: scoutTeam,
                                        nickname: registeredTeam['nameShort'],
                                        numLikes: likes != null ? likes : 0,
                                        numDislikes:
                                            dislikes != null ? dislikes : 0,
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
            }));
  }
}
