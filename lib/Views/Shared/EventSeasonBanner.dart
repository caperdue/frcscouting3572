import "package:flutter/material.dart";
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import "package:frcscouting3572/Network/firstAPI.dart" as firstAPI;
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:provider/provider.dart';

class EventSeasonBanner extends StatefulWidget {

  EventSeasonBanner();

  @override
  State<EventSeasonBanner> createState() => _EventSeasonBannerState();
}

class _EventSeasonBannerState extends State<EventSeasonBanner> {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    var screenWidth = MediaQuery.of(context).size;
    return userBloc.user.eventCode != null
        ? FutureBuilder(
            future: firstAPI.getEventInformation(
                userBloc.user.eventCode!, userBloc.user.season),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<String, String> eventInformation =
                      snapshot.data as Map<String, String>;
                  String eventName = eventInformation["eventName"]!;
                  String seasonName = eventInformation["seasonName"]!;
                  String startDate = eventInformation["startDate"]!;
                  String endDate = eventInformation["endDate"]!;

                  return Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Color.fromARGB(72, 21, 176, 176),
                          width: screenWidth.width,
                          child: Text(
                            seasonName,
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
                                  eventName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "$startDate - $endDate",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 1),
                      ],
                    ),
                  );
                } catch (e) {
                  showErrorDialogMessage(context, e.toString());
                }
              }

              return Container();
            })
        : Container();
  }
}
