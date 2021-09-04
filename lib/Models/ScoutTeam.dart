class ScoutTeam {
  late int number;
  late int likeStatus;
  late int comments;
  late var images;
  late Map<String, dynamic> stats;

  ScoutTeam.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    likeStatus = json['likeStatus'];
    comments = json['comments'];
    images = json['images'];
    stats = json['stats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['number'] = this.number;
    data['likeStatus'] = this.likeStatus;
    data['comments'] = this.comments;
    data['images'] = this.images;
    data['stats'] = this.stats;
    return data;
  }
}