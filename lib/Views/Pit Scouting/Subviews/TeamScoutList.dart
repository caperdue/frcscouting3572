import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Models/Team.dart';
import 'package:frcscouting3572/Models/blocs/QueryBloc.dart';
import 'package:frcscouting3572/Models/blocs/ScoutDataBloc.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/TeamCard.dart';
import 'package:frcscouting3572/Views/Pit%20Scouting/Subviews/ViewTeam.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:provider/provider.dart';

import '../../../Network/firstAPI.dart' as firstAPI;

// ignore: must_be_immutable
class TeamScoutList extends StatelessWidget {
  List<dynamic> frcTeams = [];

  Future<List> getScoutData(
      int season, String eventCode, int assignedTeam, String searchText) async {
    List<dynamic> allScoutInformation = [];
    List<Team> teamsFromAPI =
        List<Team>.from(await firstAPI.getTeamsByEvent(season, eventCode));
    List<Team> teams = queryTeams(teamsFromAPI, searchText);
    allScoutInformation.add(teams);
    List<int> teamNums = [];
    String commaSeparatedTeamNums = "";
    teams.forEach((team) {
      teamNums.add(team.teamNumber);
    });

    commaSeparatedTeamNums = teamNums.join(",");
    var scoutDataJSON = await apiHelper.get(
        "ScoutData/${auth.currentUser!.uid}/teamScoutData?eventCode=$eventCode&assignedTeam=$assignedTeam&season=$season&teams=$commaSeparatedTeamNums");
    allScoutInformation.add(scoutDataJSON["message"]);
    return allScoutInformation;
  }

  List<Team> queryTeams(List<Team> teams, String searchText) {
    List<Team> filteredTeams = teams.where((team) {
      String teamNumber = team.teamNumber.toString();
      String name = team.nickname.toString();
      String lowerCaseSearch = searchText.toLowerCase();
      if (teamNumber.contains(RegExp("^$lowerCaseSearch")) ||
          name.contains(RegExp("^$lowerCaseSearch"))) {
        return true;
      }
      return false;
    }).toList();

    return filteredTeams;
  }

  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    final QueryBloc queryBloc = Provider.of<QueryBloc>(context);
    Provider.of<ScoutDataBloc>(context);
    print(userBloc.user.toJson());
    return userBloc.user.eventCode != null ? Expanded(
        child: FutureBuilder(
            future: getScoutData(userBloc.user.season, userBloc.user.eventCode!,
                userBloc.user.team, queryBloc.searchText),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  List scoutDataList = snapshot.data as List;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: scoutDataList[0].length,
                      itemBuilder: (context, index) {
                        final Team registeredTeam = scoutDataList[0][index];
                        int teamNumber = registeredTeam.teamNumber;
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
                        Map<String, dynamic> teamJSON = scoutDataList[1][index];
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
                                          registeredTeam: registeredTeam,
                                          uid: scoutDataUID,
                                          stats: null)));
                            },
                            child: TeamCard(
                                scoutTeam: scoutTeam,
                                nickname: registeredTeam.nickname,
                                numLikes: teamJSON["likes"],
                                numDislikes: teamJSON["dislikes"]));
                      });
                } catch (e) {
                  showErrorDialogMessage(context, e.toString());
                }
              }
              return Center(child: CircularProgressIndicator());
            })): Center(child: Text("Please go to settings to select an event to scout."));
  }
}
