import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Shared/Snackbar.dart';

import '../../Network/db.dart' as db;

class ViewTeam extends StatefulWidget {
  final int team;
  final bool newTeam;
  final String? nickname;
  String? uid;
  ViewTeam(
      {required this.team, required this.newTeam, this.uid, this.nickname});

  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  var formKey = GlobalKey<FormState>();
  dynamic teamInfo;
  int likedKey = 1; //Default slider value
  bool editMode = false;
  DocumentSnapshot<Map<String, dynamic>>?
      scoutTeamSnapshot; //Capture to do things later
  TextEditingController commentsController = TextEditingController();

  late ScoutTeam
      teamBeforeChanges; //This allows us to reload the previous team save state without another get request.

  List<bool> buttonState = [
    false,
    true,
    false
  ]; //Get which one is selected initially

  @override
  void initState() {
    super.initState();
    this.editMode = widget.newTeam;
    reloadTeamScoutInfo();
  }

  void grabInitialTeamScoutInfo() {}
  void setLikeStatusToggle(int selected) {
    for (int i = 0; i < buttonState.length; i++) {
      buttonState[i] = i == selected;
      likedKey = selected;
    }
  }

  void reloadTeamScoutInfo() {
    try {
      if (widget.uid != null) {
        db.grabTeam(widget.uid!).then((team) {
          //Construct object
          if (team!.data()!.isNotEmpty) {
            setState(() {
              scoutTeamSnapshot = team;
              ScoutTeam initial = new ScoutTeam.fromJson(
                  team.data()!); //Should only return one document from query
              teamBeforeChanges = initial;
              commentsController.text = initial.comments;

              //Set the like status
              buttonState[1] = false;
              buttonState[initial.likeStatus] = true;
            });
          }
        });
      }
    } catch (e) {
      print("Error reloading info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      Container(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.thumb_down,
                size: 16.0,
                color: Colors.red,
              ),
              new SizedBox(
                width: 4.0,
              ),
              new Text(
                "BAD",
                style: TextStyle(color: Colors.red),
              )
            ],
          )),
      Container(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.remove,
                size: 16.0,
                color: Colors.yellow[800],
              ),
              new SizedBox(
                width: 4.0,
              ),
              new Text("", style: TextStyle(color: Colors.yellow[800]))
            ],
          )),
      Container(
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.thumb_up,
                size: 16.0,
                color: Colors.green,
              ),
              new SizedBox(
                width: 4.0,
              ),
              new Text("LIKE", style: TextStyle(color: Colors.green))
            ],
          )),
    ];
    return Scaffold(
      floatingActionButton: Column(
        children: <Widget>[],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: this.editMode
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () async {
                  setState(() {
                    this.editMode = false;
                  });
                  if (scoutTeamSnapshot == null) {
                    //No team was created. Just exit.
                    Navigator.pop(context);
                  } else {
                    //nickController.text = teamBeforeChanges.nickname;
                    commentsController.text = teamBeforeChanges.comments;
                    setLikeStatusToggle(
                        teamBeforeChanges.likeStatus); //Just default
                  }
                })
            : BackButton(),
        title: Text(
          this.editMode
              ? 'Edit Team \n${widget.team}'
              : 'View Team \n${widget.team}',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                if (this.editMode) {
                  try {
                    int season;
                    String eventCode;
                    db.user.get().then((user) {
                      season = user["season"];
                      eventCode = user["eventCode"];
                      final newTeam = ScoutTeam(
                        number: widget.team,
                        likeStatus: likedKey,
                        comments: commentsController.text,
                        images: null,
                        stats: null,
                        createdBy: auth.currentUser!.uid,
                        season: season,
                        eventCode: eventCode,
                      );
                      db.setTeam(widget.uid, newTeam.toJson()).then((value) {
                        showSnackBar(context, 'Saved successfully!', kGreen);
                        setState(() {
                          this.editMode = !this.editMode;
                        });
                        teamBeforeChanges = newTeam;
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  } catch (e) {
                    showSnackBar(
                        context,
                        'There was an error while saving. Please try again: $e',
                        kRed);
                  }
                } else {
                  setState(() {
                    this.editMode = !this.editMode;
                  });
                }
              },
              child: Text(this.editMode ? 'Save' : 'Edit'))
        ],
      ),
      body: Stack(
        children: [
          if (widget.nickname != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.nickname!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: 
                          ToggleButtons(
                            borderColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            children: buttons,
                            isSelected: buttonState,
                            onPressed: (int index) {
                              if (editMode) {
                                setState(() {
                                  setLikeStatusToggle(index);
                                });
                              }
                            },
                          )
                    ),
                    TextFormField(
                      controller: commentsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: 'Comments',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        enabled: this.editMode,
                      ),
                    ),
                    Card(
                      child: ListTile(title: Text("STATS", style:TextStyle(color: kNavy, fontWeight: FontWeight.bold)))
                    ),
                    Card(
                        child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height:5),
                                Text("SCHOOL:"),
                                Text("ROOKIE YEAR:" ),
                                Text("CITY:" ),
                                Text("STATE:" ),
                                Text("WEBSITE:"),
                                
                              ],
                            ),
                            title: Text(
                                "MORE ABOUT ${widget.nickname != null ? widget.nickname : widget.team}",
                                style: TextStyle(color: kNavy, fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
