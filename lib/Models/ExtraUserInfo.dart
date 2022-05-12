class ExtraUserInfo {
  late String uuid;
  late String? seasonDesc;
  late String? eventName;
  late String? startDate;
  late String? endDate;

  ExtraUserInfo(
      {required this.uuid,
      required this.eventName,
      required this.startDate,
      required this.endDate,
      required this.seasonDesc});

  //Converts json to ExtraUserInfo object
  ExtraUserInfo.fromJson(Map<String, dynamic> json) {
    uuid = json["uuid"];
    eventName = json["eventName"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    seasonDesc = json["seasonDesc"];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["eventName"] = this.eventName;
    data["startDate"] = this.startDate;
    data["endDate"] = this.endDate;
    data["seasonDesc"] = this.seasonDesc;
    return data;
  }
}
