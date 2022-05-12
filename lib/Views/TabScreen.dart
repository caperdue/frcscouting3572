import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Views/Match%20Data/MatchData.dart';
import 'package:frcscouting3572/Views/Pit Scouting/Scout.dart';
import 'package:frcscouting3572/Views/Settings/Settings.dart' as Settings;

class TabScreen extends StatelessWidget {
  TabScreen();
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text("FRC Scouting"),
            bottom: PreferredSize(
                preferredSize: new Size(0, 30.0),
                child: Column(
                  children: <Widget>[
                    TabBar(
                      indicatorColor: Colors.lightBlueAccent,
                      splashFactory: NoSplash.splashFactory,
                      tabs: [
                        Tab(
                          height: 40,
                          //  text: 'Scout',
                          icon: Icon(
                            Icons.leaderboard,
                          ),
                        ),
                        Tab(
                          height: 40,
                          // textIcons.leaderboard 'Match',
                          icon: Icon(
                            Icons.public,
                          ),
                        ),
                        Tab(
                          height: 40,
                          // text: 'Stats',
                          icon: Icon(Icons.precision_manufacturing),
                        ),
                        Tab(
                          height: 40,
                          // text: 'Settings',
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          body: TabBarView(children: [
            Scout(),
            MatchData(),
            Text('Tab 3'),
            Settings.Settings(), //TODO: fix this ugliness!
          ])),
    );
  }
}
