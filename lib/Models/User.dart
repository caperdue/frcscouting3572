class User {
  int team = 0;
  int season = DateTime.now().year;
  String? eventCode;
  String? district;
  String name = "";

  User({required this.team, required this.name});

  //Converts json to user object
  User.fromJson(Map<String, dynamic> json) {
    team = json["team"];
    season = json["season"];
    eventCode = json["eventCode"];
    district = json["district"];
    name = json["name"];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team'] = this.team;
    data["season"] = this.season;
    data["eventCode"] = this.eventCode;
    data["district"] = this.district;
    data["name"] = this.name;
    
    return data;
  }
}
