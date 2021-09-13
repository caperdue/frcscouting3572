import 'package:flutter/material.dart';


class ViewTeam extends StatefulWidget {
  final int? team;
  ViewTeam(this.team);

  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team == null ? 'Scout New Team' : 'Edit Team ${widget.team}'),
      ),
    );
  }
}
