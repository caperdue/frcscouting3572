class ScoutTeam {
  late String createdBy;
  late int number;
  late int likeStatus;
  late String comments;
  late String eventCode;
  late int season;
  late dynamic images;
  late int assignedTeam;
  late Map<String, dynamic>? stats;
  //late String nickname;

  ScoutTeam(
      {required this.number,
      //required this.nickname,
      required this.likeStatus,
      required this.comments,
      required this.images,
      required this.stats,
      required this.createdBy,
      required this.eventCode,
      required this.assignedTeam,
      required this.season});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['number'] = this.number;
    data['likeStatus'] = this.likeStatus;
    data['comments'] = this.comments;
    data['images'] = this.images;
    data['stats'] = this.stats;
    // data['nickname'] = this.nickname;
    data['createdBy'] = this.createdBy;
    data['season'] = this.season;
    data['eventCode'] = this.eventCode;
    data['assignedTeam'] = this.assignedTeam;
    return data;
  }

  ScoutTeam.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    likeStatus = json['likeStatus'];
    comments = json['comments'];
    images = json['images'];
    stats = json['stats'];
    // nickname = json['nickname'];
    createdBy = json['createdBy'];
    season = json['season'];
    eventCode = json['eventCode'];
    assignedTeam = json['assignedTeam'];
  }
}
