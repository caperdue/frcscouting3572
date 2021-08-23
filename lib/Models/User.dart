class User {
  int? team;
  int? scoutData;

  User({this.team});

  //Converts json to user object
  User.fromJson(Map<String, dynamic> json) {
    team = json['team'];
    scoutData = json['scoutData'];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team'] = this.team;
    data['scoutData'] = this.scoutData;
    return data;
  }
}