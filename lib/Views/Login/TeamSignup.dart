import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Models/Team.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/TabScreen.dart';
import '../Shared/DialogMessage.dart';

class TeamSignup extends StatefulWidget {
  _TeamSignupState createState() => _TeamSignupState();
}

class _TeamSignupState extends State<TeamSignup> {
  User? user;
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>(); //Use for validation
  final teamController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();

  Team? team;

  dynamic teamValidationMsg;
  dynamic codeValidationMsg;
  dynamic nameValidationMsg;

  void validateTeamNumber(String text) async {
    try {
      teamValidationMsg = null;
      setState(() {});
      if (text.isEmpty) {
        teamValidationMsg = 'Please enter team number';
        setState(() {});
        return;
      }

      if (int.tryParse(text) == null) {
        teamValidationMsg = 'Team number input must be numbers only';
        setState(() {});
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  void validateTeamCode(String text) async {
    codeValidationMsg = null;
    setState(() {});
    if (text.isEmpty) {
      codeValidationMsg = 'Please enter team code';
      setState(() {});
      return;
    }

    if (team != null && team?.code != text) {
      codeValidationMsg = 'Code is incorrect';
      setState(() {});
      return;
    }
  }

  void startSignupProcess(bool creating) async {
    if (formKey.currentState!.validate()) {
      if (creating) {
        print("Team doesn't exist yet!");
        Team newTeam = Team(
            number: int.parse(teamController.text),
            owner: auth.currentUser!.email!,
            code: codeController.text);

        await apiHelper.post("Teams/${newTeam.number}/create", newTeam);
        this.team = newTeam;
      }
      User user = User(team: this.team!.number, name: nameController.text);

      var response =
          await apiHelper.post("Users/${auth.currentUser!.uid}/create", user);
      this.user = User.fromJson(response);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: kGreen,
          content: Text("Successfully joined team ${this.team!.number}")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return TabScreen(user: user);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Team Signup'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: teamController,
                  decoration: InputDecoration(labelText: "Team Number"),
                  keyboardType: TextInputType.number,
                  validator: (value) => teamValidationMsg,
                ),
                TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(labelText: "Team Code"),
                    validator: (value) => codeValidationMsg),
                TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (value) => nameValidationMsg),
                Expanded(child: SizedBox()),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        this.team = null;
                        validateTeamNumber(teamController.text);
                        var teamJson =
                            await apiHelper.get("Teams/${teamController.text}");
                        this.team = Team.fromJson(teamJson);
                        validateTeamCode(codeController.text);
                        startSignupProcess(false);
                      } on NotFoundException catch (e) {
                        // Team was not found, go through the process of creating a team
                        startSignupProcess(true);
                      } catch (e) {
                        showDialogMessage(context, "Error",
                            "There was an error in the sign in process. Please try again. $e");
                      }
                    },
                    child: Text('Join Team')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
