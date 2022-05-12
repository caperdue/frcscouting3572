class Team {
  late final int teamNumber;
  late final String? nickname;
  late final String? schoolName;
  late final int? rookieYear;
  late final String? city;
  late final String? state;


  Team({required this.nickname, required this.schoolName, required this.rookieYear, required this.city, required this.teamNumber, required this.state});

  //Converts json to user object
 Team.fromJson(Map<String, dynamic> json) {
    teamNumber = json["teamNumber"];
    nickname = json["nickname"];
    schoolName = json["schoolName"];
    city = json["city"];
    state = json["state"];
  }

  //Takes object to be put into JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["teamNumber"] = this.teamNumber;
    data["nickname"] = this.nickname;
    data["schoolName"] = this.schoolName;
    data["city"] = this.city;
    data["state"] = this.state;
    
    return data;
  }                       
}
