import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/TeamCard.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/ViewTeam.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:provider/provider.dart';

import '../../../Network/firstAPI.dart' as firstAPI;

// ignore: must_be_immutable
class TeamScoutList extends StatefulWidget {
  String searchText;
  TeamScoutList({required this.searchText});
  List<dynamic> frcTeams = [];

  @override
  _TeamScoutListState createState() => _TeamScoutListState();
}

class _TeamScoutListState extends State<TeamScoutList> {
  dynamic scoutedTeams = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List> getScoutData(
      int season, String eventCode, int assignedTeam) async {
    List<dynamic> allScoutInformation = [];
    List<dynamic> teamsFromAPI =
        await firstAPI.getTeamsAtEvent(season, eventCode);
    List<dynamic> teams = queryTeams(teamsFromAPI);
    allScoutInformation.add(teams);
    List<int> teamNums = [];
    String commaSeparatedTeamNums = "";
    teams.forEach((team) {
      teamNums.add(team["teamNumber"]);
    });

    commaSeparatedTeamNums = teamNums.join(",");
    allScoutInformation.add(await apiHelper.get(
        "ScoutData/${auth.currentUser!.uid}/teamScoutData?eventCode=eventCode&assignedTeam=$assignedTeam&season=$season&teams=$commaSeparatedTeamNums"));
    return allScoutInformation;
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
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    print(auth.currentUser);
    return Expanded(
        child: FutureBuilder(
            future: getScoutData(userBloc.user.season, userBloc.user.eventCode!,
                userBloc.user.team),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  List scoutDataList = snapshot.data as List;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: scoutDataList[0].length,
                      itemBuilder: (context, index) {
                        final registeredTeam = scoutDataList[0][index];
                        int teamNumber = registeredTeam["teamNumber"];
                        ScoutTeam scoutTeam = ScoutTeam(
                            scoutedTeam: teamNumber,
                            likeStatus: 1,
                            comments: "",
                            images: null,
                            stats: null,
                            createdBy: auth.currentUser!.uid,
                            eventCode: userBloc.user.eventCode!,
                            season: userBloc.user.season,
                            assignedTeam: userBloc.user.team);
                        String? scoutDataUID;
                        Map<String, dynamic> teamJSON =
                            scoutDataList[1][index]; // THIS LINE FAILS

                        if (teamJSON["scoutData"] != null) {
                          Map<String, dynamic> scoutDataJSON =
                              teamJSON["scoutData"]["data"];
                          scoutTeam = ScoutTeam.fromJson(scoutDataJSON);
                          scoutDataUID = teamJSON["scoutData"]["uuid"];
                        }

                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewTeam(
                                          scoutTeam: scoutTeam,
                                          school: registeredTeam["schoolName"],
                                          rookieYear:
                                              registeredTeam["rookieYear"],
                                          city: registeredTeam["city"],
                                          state: registeredTeam["stateProv"],
                                          nickname: registeredTeam["nameShort"],
                                          stats: {},
                                          uid: scoutDataUID))).then((val) {
                                setState(() {});
                              });
                            },
                            child: TeamCard(
                                scoutTeam: scoutTeam,
                                nickname: registeredTeam['nameShort'],
                                numLikes: teamJSON["likes"],
                                numDislikes: teamJSON["dislikes"]));
                      });
                } catch (e) {
                  showErrorDialogMessage(context, e.toString());
                }
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
