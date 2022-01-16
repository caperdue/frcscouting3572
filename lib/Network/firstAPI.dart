import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String authToken = "cpchicken:c268bdc2-540d-4857-96bf-a7ed2d877fd5";
final bytes = convert.utf8.encode(authToken);
String encodedAuthToken = convert.base64.encode(bytes);

Future getTeamsAtEvent() async {
  final teams;
  final response = await http.get(
      Uri.parse(
          "https://frc-api.firstinspires.org/v3.0/2019/teams?eventCode=MIFOR"),
      headers: {"Authorization": "Basic $encodedAuthToken"});
  if (response.statusCode == 200) {
    teams = convert.jsonDecode(response.body)['teams'];
    print(teams.length);
    return teams;
  } else {
    print("Failed to return teams from event");
  }
}

Future getTeamInfo(int team) async {
  final response = await http.get(
      Uri.parse("https://frc-api.firstinspires.org/v3.0/2022/teams?teamNumber=$team"),
      headers: {"Authorization": "Basic $encodedAuthToken"});
  if (response.statusCode == 200) {
  } else {
    print("Failed to return team");
  }
}
