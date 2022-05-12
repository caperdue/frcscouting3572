class Event {
  late String eventCode;
  late String startDate;
  late String endDate;
  late String name;

  Event(
      {required this.eventCode,
      required this.startDate,
      required this.endDate,
      required this.name});

  Event.fromJson(Map<String, dynamic> json) {
    eventCode = json["eventCode"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["eventCode"] = this.eventCode;
    data["startDate"] = this.startDate;
    data["endDate"] = this.endDate;
    data["name"] = this.name;

    return data;
  }
}
