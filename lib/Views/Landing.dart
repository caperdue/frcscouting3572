import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Views/Login/Login.dart';
import 'package:frcscouting3572/Views/Login/TeamSignup.dart';
import 'package:frcscouting3572/Views/TabScreen.dart';
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
      print(auth.currentUser);
      if (auth.currentUser != null) {
        properlyAuthed = true;
        dynamic response =
            await apiHelper.get("Users/${auth.currentUser!.uid}");
        user = User.fromJson(response);
        teamAssigned = true;
      }
    } on NotFoundException catch (e) {
      print(e.cause); // User was not found, must go through creation process.
    } catch (e) {
      print(
          "An error occurred checking authentication status. Please try again. $e");
    }
  }

  void redirectUser() async {
    await checkAuth();
    if (properlyAuthed && teamAssigned) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return TabScreen(user: user!);
      }));
    } else if (!properlyAuthed) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(user: user),
          ));
    } else if (properlyAuthed && !teamAssigned) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return TeamSignup();
          });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      redirectUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
