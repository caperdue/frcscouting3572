import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import '../../Constants.dart';

class TeamCard extends StatefulWidget {
  final ScoutTeam scoutTeam;
  final String? nickname;
  final int numLikes;
  final int numDislikes;
  const TeamCard({required this.scoutTeam, required this.nickname, required this.numLikes, required this.numDislikes});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: screenSize.width / 6,
                child: Text(
                  widget.scoutTeam.number.toString(),
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
              //likeView(),
              Text("${widget.numLikes}"),
              SizedBox(width: 2),
              Icon(widget.scoutTeam.likeStatus == 2 ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined, size: 12, color: Colors.green),
              SizedBox(width: 4),
              Text("${widget.numDislikes}"),
              SizedBox(width: 2),
              Icon(widget.scoutTeam.likeStatus == 0 ? Icons.thumb_down_alt_rounded : Icons.thumb_down_alt_outlined, size: 12, color: Colors.red)
            ],
          ),
          //LikeView(),

          tileColor: Colors.white38),
    );
  }

  Widget likeView() {
    switch (widget.scoutTeam.likeStatus) {
      case 0:
        return Icon(
          Icons.thumb_down_alt_rounded,
          color: kRed,
        );
      case 1:
        return Text('');
      case 2:
        return Icon(Icons.thumb_up_alt_rounded, color: kGreen);
      default:
        return Text('none');
    }
  }
}
