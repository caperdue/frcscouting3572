import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';
import 'package:frcscouting3572/Models/Team.dart';
import 'package:frcscouting3572/Models/blocs/ScoutDataBloc.dart';
//import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Shared/CustomToggleButtons.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ViewTeam extends StatefulWidget {
  final ScoutTeam scoutTeam;
  String? uid;
  final Team registeredTeam;
  final Map<String, dynamic>? stats;

  ViewTeam(
      {required this.scoutTeam,
      required this.registeredTeam,
      this.stats,
      this.uid});

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
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    final ScoutDataBloc scoutDataBloc = Provider.of<ScoutDataBloc>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final List<Widget> buttons = [
      Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          width: screenSize.width / 8,
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
          width: screenSize.width / 8,
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
          width: screenSize.width / 8,
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
                      scoutDataBloc.edit(scoutTeam);
                    } else {
                      await apiHelper.post("ScoutData/create", scoutTeam);
                      scoutDataBloc.add(scoutTeam);
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                        color: kAquaMarine,
                        width: screenSize.width,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                    "${widget.registeredTeam.nickname}", textAlign: TextAlign.center,
                    style: TextStyle(
                            fontWeight: FontWeight.bold, color: kNavy, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 35,
                          child: CustomToggleButtons(
                              buttonState: buttonState,
                              buttons: buttons,
                              enabled: editMode,
                              value: likedKey,
                              onPressed: (int index) {
                                likedKey = index;
                              }),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
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
                                Text(
                                    "School: ${widget.registeredTeam.schoolName}"),
                                Text(
                                    "Rookie Year: ${widget.registeredTeam.rookieYear}"),
                                Text("City: ${widget.registeredTeam.city}"),
                                Text("State: ${widget.registeredTeam.state}")
                              ],
                            ),
                            title: Text("Additional Information",
                                style: TextStyle(
                                    color: kNavy,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
