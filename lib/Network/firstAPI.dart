import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Network/db.dart';

String authToken = "cpchicken:c268bdc2-540d-4857-96bf-a7ed2d877fd5";
final bytes = convert.utf8.encode(authToken);
String encodedAuthToken = convert.base64.encode(bytes);

Future getTeamsAtEvent() async {
  var user = await getUserInformation();
  final teams;
  try {
    final response = await http.get(
        Uri.parse(
            "https://frc-api.firstinspires.org/v3.0/2019/teams?eventCode=${user["eventCode"]}"),
        headers: {"Authorization": "Basic $encodedAuthToken"});
    if (response.statusCode == 200) {
      teams = convert.jsonDecode(response.body)['teams'];
      return teams;
    } else {
      print("Failed to return teams from event");
    }
  } catch (e) {
    print(e);
  }
}

Future getTeamInfo(int team) async {
  final response = await http.get(
      Uri.parse(
          "https://frc-api.firstinspires.org/v3.0/2022/teams?teamNumber=$team"),
      headers: {"Authorization": "Basic $encodedAuthToken"});
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body)["teams"][0];
  } else {
    print("Failed to return team");
  }
}

Future updateEventDataIfNeeded() async {
  final teams;
  try {
    final response = await http.get(
        Uri.parse(
            "https://frc-api.firstinspires.org/v3.0/2019/teams?eventCode=MIFOR"),
        headers: {"Authorization": "Basic $encodedAuthToken"});
    if (response.statusCode == 200) {
      teams = convert.jsonDecode(response.body)['teams'];
      user.get().then((user) {
        db
            .collection("Events")
            .where("year", isEqualTo: user.get("year"))
            .where("eventCode", isEqualTo: user.get("eventCode"))
            .get()
            .then((event) {
          Map<String, List<Map<String, dynamic>>> teamsFromAPI = {"teams": []};
          getTeamsAtEvent().then((teams) {
            teams.forEach((team) {
              teamsFromAPI["teams"]?.add({
                "number": team["teamNumber"],
                "nickname": team["nameShort"]
              });
            });
            event.docs.first.reference
                .set(teamsFromAPI, SetOptions(merge: true));
          });
        });
      });
      return teams;
    } else {
      print("Failed to return teams from event");
    }
  } catch (e) {
    print(e);
  }
}

Future<List<dynamic>>? getEventsFromSeason(
    int? season, String? district) async {
  print(district);
  if (season != null) {
    final url =
        "https://frc-api.firstinspires.org/v3.0/$season/events${district != null ? ("?districtCode=${json.decode(district)["code"]}") : ""}";
    final response = await http.get(Uri.parse(url),
        headers: {"Authorization": "Basic $encodedAuthToken"});
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)["Events"].toList();
    } else {
      print("Failed to return events");
    }
  }
  return [];
}

Future<List<dynamic>>? getDistrictsFromSeason(int? season) async {
  if (season != null) {
    final response = await http.get(
        Uri.parse("https://frc-api.firstinspires.org/v3.0/$season/districts"),
        headers: {"Authorization": "Basic $encodedAuthToken"});
    if (response.statusCode == 200) {
      List<dynamic> decoded =
          json.decode(response.body)["districts"].map((item) => item).toList();
      return decoded;
    } else {
      print("Failed to return districts");
    }
  }
  return Future.error("District retrival not successful");
}


//Wrapper for API if any errors occur

