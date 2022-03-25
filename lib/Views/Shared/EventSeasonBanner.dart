import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:frcscouting3572/Models/User.dart';
import "package:frcscouting3572/Network/db.dart" as db;
import "package:frcscouting3572/Network/firstAPI.dart" as firstAPI;

class EventSeasonBanner extends StatefulWidget {
  const EventSeasonBanner({Key? key}) : super(key: key);

  @override
  State<EventSeasonBanner> createState() => _EventSeasonBannerState();
}

class _EventSeasonBannerState extends State<EventSeasonBanner> {

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: db.user.snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            DocumentSnapshot userSnapshot = snapshot.data as DocumentSnapshot;
            User user =
                new User.fromJson(userSnapshot.data() as Map<String, dynamic>);
            if (user.eventCode != null) {
              return FutureBuilder(
                  future: firstAPI.getEventInformation(
                      user.eventCode!, user.season),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, String> eventInformation =
                          snapshot.data as Map<String, String>;
                      print(eventInformation);
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
                              color: Colors.blue[200],
                              width: screenWidth.width,
                              child: Text(
                                seasonName,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              color: Colors.blue[300],
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
                          ],
                        ),
                      );
                    }
                    return Text("");
                  });
            }
          }
          return Text("Sorry, you are not logged in.");
        });
  }
}
