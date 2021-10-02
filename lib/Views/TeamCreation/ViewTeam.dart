import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';

import '../../Network/db.dart' as db;

class ViewTeam extends StatefulWidget {
  final int team;
  final bool newTeam;
  ViewTeam({required this.team, required this.newTeam});

  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  var formKey = GlobalKey<FormState>();
  int likedKey = 1; //Default slider value
  late bool editMode;
  DocumentSnapshot? scoutTeamSnapshot; //Capture to do things later
  TextEditingController nickController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  List<bool> buttonState = [false, true, false];
  final List<Widget> buttons = [
    Icon(Icons.thumb_down, color: kRed),
    Icon(
      Icons.remove,
      color: kNavy,
    ),
    Icon(
      Icons.thumb_up,
      color: kGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    this.editMode = widget.newTeam;
    db.grabTeam(widget.team).then((team) {
      //Construct object
      if (team.exists) {
        setState(() {
          print('I ran eventually');
          scoutTeamSnapshot = team;
          ScoutTeam initial = new ScoutTeam.fromJson(team.data()!);
          nickController.text = initial.nickname;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  final newTeam = ScoutTeam(
                      number: widget.team,
                      nickname: nickController.text,
                      likeStatus: likedKey,
                      comments: commentsController.text,
                      images: null,
                      stats: null);
                  db.setTeam(widget.team, newTeam.toJson()).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Saved successfully.'),
                      backgroundColor: kGreen,
                    ));
                    setState(() {
                      this.editMode = !this.editMode;
                    });
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'There was an error while saving. Please try again: $error'),
                      backgroundColor: kRed,
                    ));
                  });
                } else {
                  setState(() {
                    this.editMode = !this.editMode;
                  });
                }
              },
              child: Text(this.editMode ? 'Save' : 'Edit'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ToggleButtons(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    children: buttons,
                    isSelected: buttonState,
                    onPressed: (int index) {
                      if (editMode) {
                        setState(() {
                          for (int i = 0; i < buttonState.length; i++) {
                            buttonState[i] = i == index;
                            likedKey = index;
                          }
                        });
                      }
                    },
                  ),
                  Expanded(
                      child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Team Nickname', style: label),
                          TextFormField(
                            controller: nickController,
                            decoration: InputDecoration(
                              enabled: this.editMode,
                            ),
                          ),
                        ]),
                  )),
                  Expanded(
                      child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Comments', style: label),
                          TextFormField(
                            controller: commentsController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border:
                                  this.editMode ? OutlineInputBorder() : null,
                              enabled: this.editMode,
                            ),
                          )
                        ]),
                  )),
                ])),
      ),
    );
  }
}
