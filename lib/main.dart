import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:provider/provider.dart';
import 'Constants.dart';
import '../Views/Landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions? firebaseOptions;
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    //Configure for web
    firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyCpl3AlIFas-GOtzvKHHemlzqD1w7ov1jE",
      authDomain: "frcscouting3572.firebaseapp.com",
      projectId: "frcscouting3572",
      storageBucket: "frcscouting3572.appspot.com",
      messagingSenderId: "523751731363",
      appId: "1:523751731363:web:4721ccc41fa124dde9cf16",
      measurementId: "G-VGTNFJ5HGH",
    );
  } else if (Platform.isIOS) {
    firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyCpl3AlIFas-GOtzvKHHemlzqD1w7ov1jE",
      authDomain: "frcscouting3572.firebaseapp.com",
      projectId: "frcscouting3572",
      storageBucket: "frcscouting3572.appspot.com",
      messagingSenderId: "523751731363",
      appId: "1:523751731363:ios:59da976d5bab3fa1e9cf16",
      measurementId: "G-VGTNFJ5HGH",
    );
  } else {
    firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyCpl3AlIFas-GOtzvKHHemlzqD1w7ov1jE",
      authDomain: "frcscouting3572.firebaseapp.com",
      projectId: "frcscouting3572",
      storageBucket: "frcscouting3572.appspot.com",
      messagingSenderId: "523751731363",
      appId: "1:523751731363:android:5b94af3040bf5d6de9cf16",
      measurementId: "G-VGTNFJ5HGH",
    );
  }
  await Firebase.initializeApp(name: "FRC_Scouting", options: firebaseOptions);

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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MultiProvider(
        providers: [ChangeNotifierProvider(create: (BuildContext context) => UserBloc())],
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              primary: Colors.white,
            )),
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
          },
        ),
      ),
    );
  }
}
