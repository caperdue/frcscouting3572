import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Shared/TeamCard.dart';
import '../Constants.dart';
import '../Network/db.dart';
import '../Views/Subviews/ViewTeam.dart';
class Scout extends StatefulWidget {
  const Scout({Key? key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  String key = "0";
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> teamStream;
  List<dynamic> filteredTeams = <int>[];

  /*filterTeams(search) async {
    var docs = await teamStream.toList();
    if (docs. false)search)
  }*/
  final Map<String, Widget> tabs = {
    '0': Container(
      child: Icon(
        Icons.person,
      ),
      width: 40.0,
    ),
    '1': Container(
      child: Icon(
        Icons.groups,
      ),
      width: 40.0,
    ),
  };
  @override
  void initState() {
    super.initState();
    teamStream = user.collection('ScoutData').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CupertinoSearchTextField(
          controller: searchController,
          onChanged: (search) {


          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Viewing: ${key == '0' ? 'My Data' : 'Team\'s Data'}",
                style: theme,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: CupertinoSegmentedControl(
                    groupValue: key,
                    borderColor: kNavy,
                    selectedColor: kNavy,
                    unselectedColor: Colors.white,
                    children: tabs,
                    onValueChanged: (i) {
                      setState(() {
                        key = i.toString();
                      });
                    }),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: teamStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final teams = snapshot.data!.docs;
                //Convert stream of data into widgets
                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          user.collection('ScoutData').doc('${teams[index]['number']}').delete();
                        },
                        key: Key(index.toString()),
                        child: TeamCard(number: int.parse(teams[index]['number']), liked: 2),
                    background: Container(color: kRed),);
                  },
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTeam(null)));
              }),
        )
      ],
    );
  }
}
