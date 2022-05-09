import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
//import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ViewTeam extends StatefulWidget {
  final ScoutTeam scoutTeam;
  String? uid;
  final String? school;
  final int? rookieYear;
  final String? city;
  final String? state;
  final String? nickname;
  final Map<String, dynamic>? stats;

  ViewTeam(
      {required this.scoutTeam,
      required this.uid,
      required this.school,
      required this.rookieYear,
      required this.city,
      required this.nickname,
      required this.state,
      required this.stats});

  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  var formKey = GlobalKey<FormState>();
  var test;
  dynamic teamInfo;
  late int likedKey; //Default slider value
  bool editMode = false;
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
    this.editMode = false;
    commentsController.text = widget.scoutTeam.comments;
    likedKey = widget.scoutTeam.likeStatus;
    setLikeStatusToggle(likedKey);
  }

  void setLikeStatusToggle(int selected) {
    for (int i = 0; i < buttonState.length; i++) {
      buttonState[i] = i == selected;
      likedKey = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    final List<Widget> buttons = [
      Container(
          width: (MediaQuery.of(context).size.width) / 8,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.thumb_down,
                size: 16.0,
                color: Colors.red,
              ),
            ],
          )),
      Container(
          width: (MediaQuery.of(context).size.width) / 8,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.remove,
                size: 16.0,
                color: Colors.yellow[800],
              ),
            ],
          )),
      Container(
          width: (MediaQuery.of(context).size.width) / 8,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.thumb_up,
                size: 16.0,
                color: Colors.green,
              ),
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
                })
            : BackButton(),
        title: Text(
          "Team ${widget.scoutTeam.scoutedTeam}",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                if (this.editMode) {
                  try {
                    int season;
                    String eventCode;
                    season = userBloc.user.season;
                    eventCode = userBloc.user.eventCode!;
                    final scoutTeam = ScoutTeam(
                        scoutedTeam: widget.scoutTeam.scoutedTeam,
                        likeStatus: likedKey,
                        comments: commentsController.text,
                        images: null,
                        stats: null,
                        createdBy: auth.currentUser!.uid,
                        season: season,
                        eventCode: eventCode,
                        assignedTeam: userBloc.user.team);

                    if (widget.uid != null) {
                      await apiHelper.post(
                          "ScoutData/${widget.uid}/update", scoutTeam);
                    } else {
                      await apiHelper.post("ScoutData/create", scoutTeam);
                    }
                  } catch (e) {
                    showErrorDialogMessage(context, e.toString());
                  }
                }
                setState(() {
                  this.editMode = !this.editMode;
                });
              },
              child: Text(this.editMode ? 'Save' : 'Edit'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      "${widget.nickname}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    )),
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
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 60),
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
                        child: ListTile(
                            title: Text("STATS",
                                style: TextStyle(
                                    color: kNavy,
                                    fontWeight: FontWeight.bold)))),
                    Card(
                        child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("School: ${widget.school}"),
                                Text("Rookie Year: ${widget.rookieYear}"),
                                Text("City: ${widget.city}"),
                                Text("State: ${widget.state}")
                              ],
                            ),
                            title: Text("Additional Information",
                                style: TextStyle(
                                    color: kNavy,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
