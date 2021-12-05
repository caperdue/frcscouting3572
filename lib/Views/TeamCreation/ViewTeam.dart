import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Views/Shared/Snackbar.dart';
import 'package:frcscouting3572/Views/Shared/RobotImagePicker.dart';

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

  late ScoutTeam
      teamBeforeChanges; //This allows us to reload the previous team save state without another get request.

  List<bool> buttonState = [
    false,
    true,
    false
  ]; //Get which one is selected initially
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
    db.grabTeam(widget.team).then((team) {
      //Construct object
      if (team.exists) {
        setState(() {
          scoutTeamSnapshot = team;
          ScoutTeam initial = new ScoutTeam.fromJson(team.data()!);
          teamBeforeChanges = initial;
          nickController.text = initial.nickname;
          commentsController.text = initial.comments;

          //Set the like status
          buttonState[1] = false;
          buttonState[initial.likeStatus] = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      nickController.text = teamBeforeChanges.nickname;
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
                    final newTeam = ScoutTeam(
                        number: widget.team,
                        nickname: nickController.text,
                        likeStatus: likedKey,
                        comments: commentsController.text,
                        images: null,
                        stats: null);
                    db.setTeam(widget.team, newTeam.toJson()).then((value) {
                      showSnackBar(context, 'Saved successfully!', kGreen);
                      setState(() {
                        this.editMode = !this.editMode;
                      });
                      teamBeforeChanges = newTeam;
                    }).catchError((error) {
                      showSnackBar(
                          context,
                          'There was an error while saving. Please try again: $error',
                          kRed);
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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                          ],
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: nickController,
                              decoration: InputDecoration(
                                labelText: 'Team Name',
                                enabled: this.editMode,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ]),
                      SizedBox(height: 30),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                            )
                          ]),
                    ]))));
  }
}
