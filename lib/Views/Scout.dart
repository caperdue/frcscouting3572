import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Shared/TeamCard.dart';
import '../Constants.dart';
import '../Network/db.dart' as db;
import '../Views/TeamCreation/TeamInitializer.dart';
import '../Views/TeamCreation/ViewTeam.dart';

class Scout extends StatefulWidget {
  const Scout({Key? key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> teamStream;
  List<dynamic> filteredTeams = <int>[];

  /*filterTeams(search) async {
    var docs = await teamStream.toList();
    if (docs. false)search)
  }*/
  @override
  void initState() {
    super.initState();
    teamStream = db.user.collection('ScoutData').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CupertinoSearchTextField(
          controller: searchController,
          onChanged: (search) {},
        ),
        Expanded(
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
                                          builder: (context) =>
                                              ViewTeam(
                                                  team: teamNum, newTeam: false)));
                              }
                        });
                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          print('running');
                          db.deleteTeam(teams[index]['number']).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    const Text('Team successfully deleted')));
                          });
                        },
                        key: Key(index.toString()),
                        child: TeamCard(
                            number: teams[index]['number'],
                            liked: teams[index]['likeStatus']),
                        background: Container(color: kRed),
                      ),
                    );
                  },
                );
              }),
        ),
        SafeArea(
          child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () {
                showTeamInitializer(this.context);
              }),
        )
      ],
    );
  }
}
