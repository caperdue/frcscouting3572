import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Views/Login.dart';
import '../Views/Landing.dart';
import '../Views/TabScreen.dart';
import '../Views/TeamCreation/ViewTeam.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('Users').get().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white,
            )
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: kDarkBlue,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: kBlue,
          ),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kDarkBlue,
            displayColor: kNavy,
          ),
            appBarTheme: AppBarTheme(
            color: kNavy,
          ),
        ),
      initialRoute: '/',
      routes: {
         '/': (context) => Landing(),
          '/view': (context) => Container(),
          '/login': (context) => Login(),
          '/home': (context) => TabScreen(),
      },
    );
  }
}
