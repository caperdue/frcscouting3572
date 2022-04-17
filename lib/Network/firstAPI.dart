import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import '../Models/User.dart';

String authToken = "cpchicken:c268bdc2-540d-4857-96bf-a7ed2d877fd5";
final bytes = convert.utf8.encode(authToken);
String encodedAuthToken = convert.base64.encode(bytes);

Future getTeamsAtEvent(User user) async {
  List<dynamic> teams;
  final response = await http.get(
      Uri.parse(
          "https://frc-api.firstinspires.org/v3.0/${user.season}/teams?eventCode=${user.eventCode}"),
      headers: {"Authorization": "Basic $encodedAuthToken"});

  if (response.statusCode == 200) {
    teams = convert.jsonDecode(response.body)['teams'];
    return teams;
  }
  return Future.error("Failed to return teams from event");
}

Future getTeamInfo(int team) async {
  final response = await http.get(
      Uri.parse(
          "https://frc-api.firstinspires.org/v3.0/2022/teams?teamNumber=$team"),
      headers: {"Authorization": "Basic $encodedAuthToken"});
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body)["teams"][0];
  }
  return Future.error("Failed to return team");
}

Future<List<dynamic>>? getEventsFromSeason(
    int? season, String? district) async {
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

Future<List<dynamic>> getDistrictsFromSeason(int? season) async {
  if (season != null) {
    final response = await http.get(
        Uri.parse("https://frc-api.firstinspires.org/v3.0/$season/districts"),
        headers: {"Authorization": "Basic $encodedAuthToken"});
    if (response.statusCode == 200) {
      List<dynamic> decoded =
          json.decode(response.body)["districts"].map((item) => item).toList();
      return decoded;
    }
  }
  return Future.error("District retrival not successful");
}

Future<Map<String, String>> getEventInformation(
    String eventCode, int season) async {
  final response = await http.get(
      Uri.parse(
          "https://frc-api.firstinspires.org/v3.0/$season/events?eventCode=$eventCode"),
      headers: {"Authorization": "Basic $encodedAuthToken"});

  final seasonNameResponse = await http.get(
      Uri.parse("https://frc-api.firstinspires.org/v3.0/$season"),
      headers: {"Authorization": "Basic $encodedAuthToken"});

  if (response.statusCode == 200 && seasonNameResponse.statusCode == 200) {
    String eventName = json.decode(response.body)["Events"][0]["name"];
    String startDateString =
        json.decode(response.body)["Events"][0]["dateStart"];
    String endDateString = json.decode(response.body)["Events"][0]["dateEnd"];

    DateTime startDate = DateTime.parse(startDateString).toLocal();
    DateTime endDate = DateTime.parse(endDateString).toLocal();

    startDateString = DateFormat.yMMMEd().format(startDate);
    endDateString = DateFormat.yMMMEd().format(endDate);

    String seasonName = json.decode(seasonNameResponse.body)["gameName"];
    return {
      "eventName": eventName,
      "seasonName": seasonName,
      "startDate": startDateString,
      "endDate": endDateString
    };
  }
  return Future.error("There was a problem retrieving the event information.");
}
