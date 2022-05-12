class Match {
  final int season;
  final String scoutedBy;
  final int? matchNumber;
  final String? eventCode;
  String comments;

  Match(
      {required this.season,
      required this.scoutedBy,
      required this.matchNumber,
      required this.eventCode,
      required this.comments
      });
}
