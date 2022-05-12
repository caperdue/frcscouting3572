
import 'package:frcscouting3572/Models/Event.dart';
import 'package:frcscouting3572/Models/Team.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';

import 'APIHelper.dart';

Future<List<String>> getDistrictsBySeason(int season) async {
  final districtJSON = await tbaHelper.get("districts/2022") as List<dynamic>;
  List<String> districts = List<String>.from(districtJSON.map(
      (district) => district["abbreviation"]));

  return districts;
}

Future<List<Event>> getEventsByDistrictAndSeason(
    int season, String district) async {
  try {
    var eventsJSON;
    if (district != "Other") {
      eventsJSON = await tbaHelper.get("district/$season$district/events")
          as List<dynamic>;
      eventsJSON = eventsJSON.where(
          (event) => event["event_type"] == 1 || event["event_type"] == 2);
    } else {
      eventsJSON = await tbaHelper.get("events/$season") as List<dynamic>;
      eventsJSON = eventsJSON.where(
          (event) => event["event_type"] == 3 || event["event_type"] == 4);
    }
    eventsJSON = eventsJSON.map((event) => Event(
        eventCode: event["event_code"],
        startDate: event["start_date"],
        endDate: event["end_date"],
        name: event["name"]));
    List<Event> events = List<Event>.from(eventsJSON);
    return events;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<Team>> getTeamsByEvent(int season, String eventCode) async {
  var teamsJSON =
      await tbaHelper.get("event/$season$eventCode/teams") as List<dynamic>;
  List<Team> teams = List<Team>.from(teamsJSON.map((team) => Team(
      teamNumber: team["team_number"],
      schoolName: team["school_name"],
      rookieYear: team["rookie_year"],
      city: team["city"],
      state: team["state_prov"],
      nickname: team["nickname"])));

  return teams;
}

Future<dynamic> getTeam(int team) async {
  final teamJSON = await tbaHelper.get("team/$team");
  return teamJSON;
}

Future<String> getSeasonInformation(int season) async {
  final seasonNameResponse = await firstAPIHelper.get("$season");
  String seasonName = seasonNameResponse["gameName"];
  return seasonName;
}
