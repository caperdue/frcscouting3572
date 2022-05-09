import 'package:flutter/foundation.dart';
import 'package:frcscouting3572/Models/User.dart';

class UserBloc extends ChangeNotifier {
  User _user = User(name: "", team: 0);

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserInitial(User user) {
    _user = user;
  }
}
