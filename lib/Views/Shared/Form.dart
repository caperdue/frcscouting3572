import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/Team.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Network/db.dart';
import 'DialogMessage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>(); //Use for validation
  final teamController = TextEditingController();
  final codeController = TextEditingController();

  late String teamNum;
  late String teamCode;
  dynamic teamValidationMsg;
  dynamic codeValidationMsg;
  bool createState = false;

  Future checkIfTeamExists(text) async {
    teamValidationMsg = null;

    setState(() {});
    if (text == null || text.isEmpty) {
      teamValidationMsg = 'Please enter team number';
      setState(() {});
      return;
    }
    final team = await teams.doc(text).get();
    if (team.exists && createState) {
      teamValidationMsg = 'Team already exists';
      setState(() {});
      return;
    } else if (!team.exists && !createState) {
      teamValidationMsg = 'Team does not exist, perhaps create it?';
      setState(() {});
      return;
    }
  }

  Future checkValidCode(text) async {
    codeValidationMsg = null;

    setState(() {});
    if (text == null || text.isEmpty) {
      codeValidationMsg = 'Please enter team code';
      setState(() {});
      return;
    }
    final team = await teams.doc(teamController.text).get();
    if (team.exists &&
        team.get('code') != codeController.text &&
        !createState) {
      codeValidationMsg = 'Code is incorrect';
      setState(() {});
      return;
    }
  }

  Team createTeam() {
    return Team(
        number: int.parse(teamController.text),
        owner: auth.currentUser!.email!,
        code: codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
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
              Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      createState = false;
                    });
                    //Logic for joining
                    await checkIfTeamExists(teamController.text);
                    await checkValidCode(codeController.text);
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Attempting to join team ${teamController.text}...')));
                      try {
                        final tempTeam = createTeam();
                        user.update({"team": tempTeam.number});
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        showDialogMessage(context, 'Error',
                            'There was an error trying to join team. Please try again.');
                      }
                    }
                  },
                  child: Text('Join Team')),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      createState = true;
                    });

                    await checkIfTeamExists(teamController.text);
                    await checkValidCode(codeController.text);
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Attempting to create team ${teamController.text}...')));
                      try {
                        final newTeam = createTeam();
                        teams.doc('${newTeam.number}').set(newTeam.toJson());
                        user.update({"team": newTeam.number});
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        showDialogMessage(context, 'Error',
                            'There was an error trying to create team. Please try again.');
                      }
                    }
                  },
                  child: Text('Create Team')),
            ],
          ),
        ),
      ),
    );
  }
}
