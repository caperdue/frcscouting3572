import 'package:flutter/material.dart';
import 'package:frcscouting3572/Views/Shared/EventSeasonBanner.dart';
import '../Models/User.dart';
import 'Pit Scouting/Scout.dart';
import 'Settings/Settings.dart' as Settings;

// ignore: must_be_immutable
class TabScreen extends StatefulWidget {
  User user;
  TabScreen({required this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text("FRC Scouting"),
            bottom: PreferredSize(
                preferredSize: new Size(0, 75.0),
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
                    // EventSeasonBanner()
                    EventSeasonBanner(),
                  ],
                )),
          ),
          body: TabBarView(children: [
            Scout(user: widget.user),
            Text("Overall stats view"),
            Text('Tab 3'),
            Settings.Settings(user: widget.user), //TODO: fix this ugliness!
          ])),
    );
  }
}
