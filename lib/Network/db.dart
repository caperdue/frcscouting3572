import 'package:cloud_firestore/cloud_firestore.dart';
import 'Auth.dart';
import '../Models/User.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DocumentReference user = db.collection('Users').doc(auth.currentUser?.uid);
CollectionReference users = db.collection('Users');
CollectionReference teams = db.collection('Teams');
CollectionReference scoutData = db.collection('ScoutData');
//General
void createUser(int? team) {
  final newUser = User(team: team);
  users.doc(auth.currentUser!.uid).set(newUser.toJson());
}

Future<DocumentSnapshot<Object?>> getUserInformation() async {
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

Future<DocumentSnapshot<Map<String, dynamic>>?> getScoutDataByByUID(
    String uid) async {
  return await db.collection("ScoutData").doc(uid).get();
}

Future<void> updateTeam(String? uid, Map<String, dynamic> data) async {
  if (uid != null) {
    return await db
        .collection('ScoutData')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }
}

Future<DocumentReference> addTeam(Map<String, dynamic> data) async {
  return await db.collection('ScoutData').add(data);
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
            return likes;
          });
        });
      });
    }
  });
  return likes;
}

// Settings page

//Event Settings Page
Future saveSeasonInfo(String eventCode, int season, String district) async {
  var futures = <Future>[];
  final userData = await user.get();
  try {
    if (userData.exists) {
      Future setSeason;

      setSeason = userData.reference.update({"season": season});
      futures.add(setSeason);

      Future setEventCode;
      setEventCode = userData.reference.update({"eventCode": eventCode});
      futures.add(setEventCode);

      setEventCode = userData.reference.update({"district": district});
      futures.add(setEventCode);

      return await Future.wait(futures);
    }
  } catch (e) {
    throw new Error();
  }
}

Future<Map<String, int>> getTotalLikesDislikes(int teamNumber) async {
  int likeCount = 0;
  int dislikeCount = 0;
  DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
      await user.get() as DocumentSnapshot<Map<String, dynamic>>;
  final userDoc = userDocSnapshot.data();
  final userObj = User.fromJson(userDoc!);

  var teamDocSnapshot = await scoutData
      .where("number", isEqualTo: teamNumber)
      .where("eventCode", isEqualTo: userObj.eventCode)
      .where("season", isEqualTo: userObj.season)
      .where("assignedTeam", isEqualTo: userObj.team)
      .get();

  //teamDocSnapshot = teamDocSnapshot.docs.where("")
  var teamDocs = teamDocSnapshot.docs;
  for (var teamDoc in teamDocs) {
    switch (teamDoc.get("likeStatus")) {
      case 0:
        dislikeCount++;
        break;
      case 2:
        likeCount++;
        break;
    }
  }

  return {"likes": likeCount, "dislikes": dislikeCount};
}

// View Team

Future<Query?> getScoutDataByEvent() async {
  DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
      await user.get() as DocumentSnapshot<Map<String, dynamic>>;
  final userDoc = userDocSnapshot.data();
  final userObj = User.fromJson(userDoc!);

  if (auth.currentUser != null) {
    Query scoutResult = scoutData
        .where('eventCode', isEqualTo: userObj.eventCode)
        .where('season', isEqualTo: userObj.season)
        .where('assignedTeam', isEqualTo: userObj.team);

    return scoutResult;
  }
  return null;
}

Future<QueryDocumentSnapshot<Object?>?> getScoutDataByTeam(int team) async {
  DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
      await user.get() as DocumentSnapshot<Map<String, dynamic>>;
  final userDoc = userDocSnapshot.data();
  final userObj = User.fromJson(userDoc!);

  if (auth.currentUser != null) {
    Query scoutResult = scoutData
        .where('eventCode', isEqualTo: userObj.eventCode)
        .where('number', isEqualTo: team)
        .where('season', isEqualTo: userObj.season)
        .where('createdBy', isEqualTo: auth.currentUser!.uid);

    var results = await scoutResult.get();
    if (results.size == 1) {
      return results.docs.first;
    } else {
      print("There was an error grabbing the scout data");
    }
  }
  return null;
}

Future<Map<int, QueryDocumentSnapshot<Object?>>>
    getUserTeamAndSeasonScoutData() async {
  var userDocSnapshot = await user.get();
  var userDoc = userDocSnapshot.data() as Map<String, dynamic>;
  final userObj = User.fromJson(userDoc);
  Map<int, QueryDocumentSnapshot<Object?>> teams = {};
  if (auth.currentUser != null) {
    Query scoutResult = scoutData
        .where('eventCode', isEqualTo: userObj.eventCode)
        .where('season', isEqualTo: userObj.season)
        .where('createdBy', isEqualTo: auth.currentUser!.uid);

    var results = await scoutResult.get();
    var docs = results.docs;

    for (var team in docs) {
      //ScoutTeam scoutTeam = new ScoutTeam.fromJson(newTeam);
      teams[team.get("number")] = team;
    }
  }
  return teams;
}
