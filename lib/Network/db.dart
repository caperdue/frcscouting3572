import 'package:cloud_firestore/cloud_firestore.dart';
import 'Auth.dart';
import '../Models/User.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DocumentReference user = db.collection('Users').doc(auth.currentUser!.uid);
CollectionReference users = db.collection('Users');

createUser(int team) {
  final newUser = User(team: team);
  users.doc(auth.currentUser!.uid).set(newUser.toJson());
}
