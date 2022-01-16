class User {
  int? team;
  int? scoutData;
  int? season = DateTime.now().year;
  int? eventCode;

  User({this.team});

  //Converts json to user object
  User.fromJson(Map<String, dynamic> json) {
    team = json["team"];
    scoutData = json["scoutData"];
    season = json["season"];
    eventCode = json["eventCode"];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team'] = this.team;
    data['scoutData'] = this.scoutData;
    data["season"] = this.season;
    data["eventCode"] = this.eventCode;
    return data;
  }
}