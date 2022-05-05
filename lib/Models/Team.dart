class Team {
  late int number;
  late String owner;
  late String code;

  Team({required this.number, required this.owner, required this.code});

  Team.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    owner = json['owner'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['number'] = this.number;
    data['owner'] = this.owner;
    data['code'] = this.code;

    return data;
  }
}