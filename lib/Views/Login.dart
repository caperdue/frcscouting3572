import 'package:flutter/material.dart';
import '../Network/Auth.dart';
import '../Network/db.dart';
import 'Shared/DialogMessage.dart';
import 'Shared/Form.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController rotationController;
  bool showTeamOptions = false;

  @override
  void initState() {
    super.initState();
    listenAuthChanges();
   // rotationController = AnimationController(
     //   duration: const Duration(milliseconds: 10000), vsync: this);
   // rotationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('FRC Scouting Login')),
      body: auth.currentUser == null ? Center (
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () {
            signInWithGoogle().then((signedIn) {
              user.get().then((value) {
                if (value.get('team') != null) {
                 // rotationController.dispose();
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  setState(() {
                  });
                }
              });
            }).catchError((error) {
              showDialogMessage(context, 'Error', error.toString());
            });
          },
        ),

      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginForm(),
          /*Expanded(
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: kAquaMarine),
                  ),
                ),
                child: RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: Image.network(
                        'https://th.bing.com/th/id/R.b95b847283b22f26204edc9131e45e46?rik=IX3gGtZSpXG7Jw&riu=http%3a%2f%2fpre03.deviantart.net%2fc857%2fth%2fpre%2fi%2f2012%2f106%2f3%2f1%2fblue_lambda_cutie_mark_1000_pixels_by_chirochick-d4wdlg4.png&ehk=q4uIwvsAqe2NhgdEpl0pjSamzJoLpNO8K5crZJdUlWY%3d&risl=&pid=ImgRaw&r=0'))),
          ),
          SizedBox(height: 10),*/
        ],
      ),
    );
  }
}
