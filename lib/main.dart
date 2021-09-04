import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Views/Login.dart';
import '../Views/Landing.dart';
import '../Views/TabScreen.dart';

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
