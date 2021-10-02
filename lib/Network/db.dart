import 'package:cloud_firestore/cloud_firestore.dart';
import 'Auth.dart';
import '../Models/User.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DocumentReference user = db.collection('Users').doc(auth.currentUser!.uid);
CollectionReference users = db.collection('Users');
CollectionReference teams = db.collection('Teams');

void createUser(int team) {
  final newUser = User(team: team);
  users.doc(auth.currentUser!.uid).set(newUser.toJson());
}

bool checkIfTeamExists(String teamString) { //Fix me to use await
  bool exists = false;
  teams.doc(teamString).get().then((team) {
    if (team.exists) {
      exists = true;
    }
  });
  return exists;
}

Future<DocumentSnapshot<Map<String, dynamic>>> grabTeam(int team) async {
  return await user.collection('ScoutData').doc("$team").get();
}

Future deleteTeam(int team) async {
  return await user.collection('ScoutData').doc("$team").delete();
}

Future setTeam(int team, Map<String, dynamic> data) async {
  return await user.collection('ScoutData').doc("$team").set(data, SetOptions(merge: true));
}