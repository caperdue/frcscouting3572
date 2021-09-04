import 'package:flutter/material.dart';
import '../Constants.dart';

class TeamCard extends StatelessWidget {
  final int liked;
  final int number;
  TeamCard({required this.number, required this.liked});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: kRed),
      key: UniqueKey(),
      direction: DismissDirection.none, //Modify for admin stuff maybe?
      child: GestureDetector(
        onTap: (){

        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1, color: kAquaMarine),
          )),
          child: ListTile(
              title: Text(number.toString()),
              trailing: getTeamStatus(),
              tileColor: Colors.white38),
        ),
      ),
    );
  }

  Widget getTeamStatus() {
    switch (liked) {
      case 0:
        return Icon(
          Icons.thumb_down,
          color: kRed,
        );
      case 1:
        return Text('OK');
      case 2:
        return Icon(Icons.thumb_up, color: kGreen);
      default:
        return Text('');
    }
  }
}
