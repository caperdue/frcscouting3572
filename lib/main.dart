import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Network/Auth.dart';
import 'Views/Scout.dart';
import 'Constants.dart';

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
    //FirebaseFirestore.instance.collection('Users').get().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kDarkBlue,
            displayColor: kNavy,
          ),

            appBarTheme: AppBarTheme(
            color: kNavy,
          ),
        ),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text('FRC Scouting'),
              bottom: PreferredSize(
                preferredSize: new Size(0, 15.0),
                child: TabBar(
                  indicatorColor: Colors.lightBlueAccent,
                  tabs: [
                    Tab(
                      //  text: 'Scout',
                      icon: Icon(
                        Icons.feed,
                      ),
                    ),
                    Tab(
                      // text: 'Match',
                      icon: Icon(
                        Icons.precision_manufacturing,
                      ),
                    ),
                    Tab(
                      // text: 'Stats',
                      icon: Icon(Icons.leaderboard),
                    ),
                    Tab(
                      //text: 'Settings',
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
            body: signedIn
                ? TabBarView(children: [
                    Scout(),
                    Text('Tab 2'),
                    Text('Tab 3'),
                    Text('Tab 4'),
                  ])
                : Center(
                    child: ElevatedButton(
                      child: Text('Sign in with Google'),
                      onPressed: () => signInWithGoogle(),
                    ),
                  ),
          ),
        ));
  }
}
