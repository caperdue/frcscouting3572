import 'package:cloud_firestore/cloud_firestore.dart';
import 'Auth.dart';
import '../Models/User.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DocumentReference user = db.collection('Users').doc(auth.currentUser?.uid);
CollectionReference teamData = db.collection('Users').doc(auth.currentUser?.uid).collection("TeamData");
CollectionReference users = db.collection('Users');
CollectionReference teams = db.collection('Teams');

void getUser() {

}

void createUser(int? team) {
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

Future<DocumentSnapshot<Map<String, dynamic>>?> grabTeam(String uid) async {
    return await db.collection("ScoutData").doc(uid).get();
}

Future deleteTeam(String uid) async {
  try {
    return await db.collection('ScoutData').doc(uid).delete();
  }
  catch(e) {
    print("An error has occurred!");
  }
  return null;
}

Future setTeam(String? uid, Map<String, dynamic> data) async {
  if (uid != null) {
    return await db.collection('ScoutData').doc(uid).set(data, SetOptions(merge: true));
  }
  return await db.collection('ScoutData').doc().set(data, SetOptions(merge: true));
}

Future<int> getMostLiked() async {
  int? team;
  List<Map<String, int>> teams = [];
  int likes = 0;
  user.get().then((user) {
    team = user.get("team");

    if (team != null) {
      var sample = users.where("team", isEqualTo: team).get().then((values) {
        values.docs.forEach((result) { // For each user on that team...
          result.reference.collection("ScoutData").get().then((value) { // Get all teams with no. 909
            value.docs.forEach((element) {
              print(element.data());
              switch(element.data()['likeStatus']) {
                case 0:
                break;
                case 2:
                  likes++;
                break;
                default:
                break;
          }
        });
            print(likes);
            return likes;
      });
        });
    });
  }
});
  return likes;
      }