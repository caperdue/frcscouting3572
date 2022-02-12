import 'package:flutter/material.dart';
import '../../Network/db.dart';
import 'ViewTeam.dart';
//THIS FILE MAY NEED TO BE REMOVED.

class TeamInitializer extends StatefulWidget {
  @override
  _TeamInitializerState createState() => _TeamInitializerState();
}

class _TeamInitializerState extends State<TeamInitializer> {
  final formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();

  int? team;
  dynamic validateMsg;
  Future validateTeamExists(String teamNumber) async {
    validateMsg = null;

    if (teamNumber.isEmpty || teamNumber.trim() == "") {
      validateMsg = "Please enter a valid team number";
      setState(() {});
      return;
    }
    final scoutTeam = await user.collection('ScoutData').doc(teamNumber).get();

    if (scoutTeam.exists) {
      validateMsg = "Team already exists in your scout list";
      setState(() {});
      return;
    }
    else if (int.tryParse(teamNumber) == null) {
      validateMsg = "Team number must be only numeric";
      setState(() {});
      return;
    }
    else {
      if (int.parse(teamNumber) <= 0) {
        validateMsg = "Team number must be greater than 0";
        setState(() {});
        return;
      }
      else {
        team = int.tryParse(teamNumber);
        setState(() {});
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Scout New Team'),
      content: Form(
          key: formKey,
          child: Container(
            height:150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextFormField(
                  validator: (text) => validateMsg,
                  controller: numberController,
                  decoration: InputDecoration(labelText: 'Team Number'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width:10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await validateTeamExists(numberController.text);
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewTeam(team: this.team!, newTeam: true)));
                          }
                        },
                        child: Text('Next'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

showTeamInitializer(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return TeamInitializer();
      });
}
