import 'package:cloud_firestore/cloud_firestore.dart';
import 'Auth.dart';
import '../Models/User.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DocumentReference user = db.collection('Users').doc(auth.currentUser?.uid);
CollectionReference teamData =
    db.collection('Users').doc(auth.currentUser?.uid).collection("TeamData");
CollectionReference users = db.collection('Users');
CollectionReference teams = db.collection('Teams');
CollectionReference events = db.collection('Events');
//General
void createUser(int? team) {
  final newUser = User(team: team);
  users.doc(auth.currentUser!.uid).set(newUser.toJson());
}

Future getUserInformation() async {
  return await user.get();
}

bool checkIfTeamExists(String teamString) {
  //Fix me to use await
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

Future setTeam(String? uid, Map<String, dynamic> data) async {
  if (uid != null) {
    return await db
        .collection('ScoutData')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }
  return await db
      .collection('ScoutData')
      .doc()
      .set(data, SetOptions(merge: true));
}

Future<int> getMostLiked() async {
  int? team;
  int likes = 0;
  user.get().then((user) {
    team = user.get("team");

    if (team != null) {
      users.where("team", isEqualTo: team).get().then((values) {
        values.docs.forEach((result) {
          // For each user on that team...
          result.reference.collection("ScoutData").get().then((value) {
            // Get all teams with no. 909
            value.docs.forEach((element) {
              print(element.data());
              switch (element.data()['likeStatus']) {
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

// Settings page
Future<List<dynamic>> getSeasons() async {
  var seasons = await db.collection("Seasons").get();
  List seasonData = seasons.docs.map((seasonItem) {
    return seasonItem.data()["year"];
  }).toList();
  seasonData = seasonData.toList();
  seasonData = seasonData..sort((a, b) => b.compareTo(a));
  return seasonData;
}

//Event Settings Page
Future saveEventAndSeason(String eventCode, int season) async {
  final userData = await user.get();
  if (userData.exists) {
    var futures = <Future>[];
    Future setSeason;
    if (userData.get("season") != season) {
      setSeason =
          userData.reference.set({"season": season}, SetOptions(merge: true));
      futures.add(setSeason);
    }
    Future setEventCode;
    if (userData.get("eventCode") != eventCode) {
      setEventCode = userData.reference
          .set({"eventCode": eventCode}, SetOptions(merge: true));
      futures.add(setEventCode);
    }
    return await Future.wait(futures);
  }
}
//TODO: Save event to database and load from there for caching benefits.
Future saveEvent(String eventCode) async {
  final eventData = await events.get();


}
