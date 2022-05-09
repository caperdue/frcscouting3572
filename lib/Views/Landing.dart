import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Views/Login/Login.dart';
import 'package:frcscouting3572/Views/Login/TeamSignup.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:frcscouting3572/Views/TabScreen.dart';
import 'package:provider/provider.dart';
import '../Network/Auth.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  User? user;
  bool properlyAuthed = false;
  bool teamAssigned = false;
  Future checkAuth() async {
    try {
      if (auth.currentUser != null) {
        properlyAuthed = true;
        dynamic response =
            await apiHelper.get("Users/${auth.currentUser!.uid}");
        this.user = User.fromJson(response);
        teamAssigned = true;
      }
    } on NotFoundException catch (e) {
      print(e.cause); // User was not found, must go through creation process.
    } catch (e) {
      print(
          "An error occurred checking authentication status. Please try again. $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);

    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1), () => true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            checkAuth().then((auth) {
              if (properlyAuthed && teamAssigned) {
                userBloc.setUserInitial(this.user!);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return TabScreen();
                }));
              } else if (!properlyAuthed) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
              } else if (properlyAuthed && !teamAssigned) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return TeamSignup();
                    });
              } else {
                showErrorDialogMessage(context, "Error during sign in process");
              }
            });
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
