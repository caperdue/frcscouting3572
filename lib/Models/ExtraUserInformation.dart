import 'package:frcscouting3572/Models/Event.dart';

class ExtraUserInformation {
  late String uuid;
  late String? seasonDesc;
  late Event event;

  ExtraUserInformation(
      {required this.uuid,
      required this.event,
      required this.seasonDesc});

  //Converts json to ExtraUserInformation object
  ExtraUserInformation.fromJson(Map<String, dynamic> json) {
    uuid = json["uuid"];
    event = json["event"];

    seasonDesc = json["seasonDesc"];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["event"] = this.event;
    data["seasonDesc"] = this.seasonDesc;
    return data;
  }
}
