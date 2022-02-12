class Event {
  late String eventCode;
  late String name;
  late int year;
  late List<Map<int, String>> teams;

  Event({required this.eventCode, required this.name, required this.year});

  Event.fromJson(Map<String, dynamic> json) {
    eventCode = json['year'];
    name = json['name'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['eventCode'] = this.eventCode;
    data['name'] = this.name;
    data['year'] = this.year;
    data['teams'] = this.teams;
    return data;
  }
}
