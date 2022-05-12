import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import '../../../Constants.dart';

class TeamCard extends StatelessWidget {
  final ScoutTeam scoutTeam;
  final String? nickname;
  final int numLikes;
  final int numDislikes;
  const TeamCard({required this.scoutTeam, required this.nickname, required this.numLikes, required this.numDislikes});

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
                  this.scoutTeam.scoutedTeam.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kNavy, fontWeight: FontWeight.bold),
                ),
              ),
              //     if (this.nickname != null)
              if (this.nickname != null) Text("|"),
              if (this.nickname != null) SizedBox(width: 5),
              if (this.nickname != null)
                Expanded(
                    child: Text(
                  this.nickname!,
                  style: TextStyle(fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                )),
              //likeView(),
              Text("${this.numLikes}"),
              SizedBox(width: 2),
              Icon(this.scoutTeam.likeStatus == 2 ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined, size: 12, color: Colors.green),
              SizedBox(width: 4),
              Text("${this.numDislikes}"),
              SizedBox(width: 2),
              Icon(this.scoutTeam.likeStatus == 0 ? Icons.thumb_down_alt_rounded : Icons.thumb_down_alt_outlined, size: 12, color: Colors.red)
            ],
          ),
          //LikeView(),

          tileColor: Colors.white),
    );
  }

  Widget likeView() {
    switch (this.scoutTeam.likeStatus) {
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
