class ScoutTeam {
  late String createdBy;
  late int scoutedTeam;
  late int likeStatus;
  late String comments;
  late String eventCode;
  late int season;
  late dynamic images;
  late int assignedTeam;
  late Map<String, dynamic>? stats;

  ScoutTeam(
      {required this.scoutedTeam,
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
    data['scoutedTeam'] = this.scoutedTeam;
    data['likeStatus'] = this.likeStatus;
    data['comments'] = this.comments;
    data['images'] = this.images;
    data['stats'] = this.stats;
    data['createdBy'] = this.createdBy;
    data['season'] = this.season;
    data['eventCode'] = this.eventCode;
    data['assignedTeam'] = this.assignedTeam;
    return data;
  }

  ScoutTeam.fromJson(Map<String, dynamic> json) {
    scoutedTeam = json['scoutedTeam'];
    likeStatus = json['likeStatus'];
    comments = json['comments'];
    images = json['images'];
    stats = json['stats'];
    createdBy = json['createdBy'];
    season = json['season'];
    eventCode = json['eventCode'];
    assignedTeam = json['assignedTeam'];
  }
}
