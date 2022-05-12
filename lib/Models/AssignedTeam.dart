class AssignedTeam {
  late int number;
  late String owner;
  late String code;

  AssignedTeam({required this.number, required this.owner, required this.code});

  AssignedTeam.fromJson(Map<String, dynamic> json) {
    number = json["number"];
    owner = json["owner"];
    code = json["code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["number"] = this.number;
    data["owner"] = this.owner;
    data["code"] = this.code;

    return data;
  }
}