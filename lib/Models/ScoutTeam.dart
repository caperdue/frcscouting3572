class ScoutTeam {
  late int number;
  late int likeStatus;
  late String comments;
  late dynamic images;
  late Map<String, dynamic>? stats;
  late String nickname;

  ScoutTeam({required this.number, required this.nickname, required this.likeStatus, required this.comments, required this.images, required this.stats});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['number'] = this.number;
    data['likeStatus'] = this.likeStatus;
    data['comments'] = this.comments;
    data['images'] = this.images;
    data['stats'] = this.stats;
    data['nickname'] = this.nickname;
    return data;
  }

  ScoutTeam.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    likeStatus = json['likeStatus'];
    comments = json['comments'];
    images = json['images'];
    stats = json['stats'];
    nickname = json['nickname'];
  }
}