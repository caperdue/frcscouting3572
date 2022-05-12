import "package:flutter/material.dart";
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:provider/provider.dart';

class EventSeasonBanner extends StatelessWidget {
  EventSeasonBanner();

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    var screenWidth = MediaQuery.of(context).size;
    return userBloc.user.eventCode != null
        ? Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Color.fromARGB(72, 21, 176, 176),
                  width: screenWidth.width,
                  child: Text(
                    userBloc.extraUserInfo.seasonDesc!,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: screenWidth.width,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          userBloc.extraUserInfo.eventName!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        //TODO: make sure this has dateformat implement
                        Text(
                          "${userBloc.extraUserInfo.startDate} - ${userBloc.extraUserInfo.endDate}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1),
              ],
            ),
          )
        : Container();
  }
}
