import 'package:flutter/material.dart';
import 'Scout.dart';
import 'Settings.dart';

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
            title: Text('FRC Scouting'),
            bottom: PreferredSize(
              preferredSize: new Size(0, 15.0),
              child: TabBar(
                indicatorColor: Colors.lightBlueAccent,
                tabs: [
                  Tab(
                    //  text: 'Scout',
                    icon: Icon(
                      Icons.leaderboard,
                    ),
                  ),
                  Tab(
                    // textIcons.leaderboard 'Match',
                    icon: Icon(
                      Icons.public,
                    ),
                  ),
                  Tab(
                    // text: 'Stats',
                    icon: Icon(Icons.precision_manufacturing),
                  ),
                  Tab(
                    //text: 'Settings',
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            Scout(),
            Text('Tab 2'),
            Text('Tab 3'),
            Settings(),
          ])),
    );
  }
}
