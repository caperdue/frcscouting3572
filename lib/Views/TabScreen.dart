import 'package:flutter/material.dart';
import 'package:frcscouting3572/Views/Shared/EventSeasonBanner.dart';
import 'Scout.dart';
import 'Settings/Settings.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

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
              child:
                Column(
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
                  EventSeasonBanner(),],
                ),
             
            ),
          ),
          body: TabBarView(children: [
            Scout(),
            Text("Overall stats view"),
            Text('Tab 3'),
            Settings(),
          ])),
    );
  }
}
