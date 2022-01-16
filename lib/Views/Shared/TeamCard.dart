import 'package:flutter/material.dart';
import 'package:frcscouting3572/Network/db.dart';
import '../../Constants.dart';

class TeamCard extends StatefulWidget {
  final int? liked;
  final int number;
  final bool? global;
  final String? nickname;

  const TeamCard(
      {Key? key, this.liked, this.nickname, required this.number, this.global})
      : super(key: key);

  @override
  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: kAquaMarine),
      )),
      child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: screenSize.width / 6,
                child: Text(
                  widget.number.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kNavy, fontWeight: FontWeight.bold),
                ),
              ),
              //     if (widget.nickname != null)
              if (widget.nickname != null) Text("|"),
              if (widget.nickname != null) SizedBox(width: 5),
              if (widget.nickname != null)
                Expanded(
                    child: Text(
                  widget.nickname!,
                  style: TextStyle(fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                )),
                  getTeamStatus(),
                  Text("0 likes"),

            ],
          ),
             //getTeamStatus(),
               
          tileColor: Colors.white38),
    );
  }

  Widget getTeamStatus() {
    switch (widget.liked) {
      case 0:
        return Icon(
          Icons.thumb_down,
          color: kRed,
        );
      case 1:
        return Text('');
      case 2:
        return Icon(Icons.thumb_up, color: kGreen);
      default:
        return Text('none');
    }
  }
}
