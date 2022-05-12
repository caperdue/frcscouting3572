import 'package:flutter/foundation.dart';
import 'package:frcscouting3572/Models/Event.dart';
import 'package:frcscouting3572/Models/ExtraUserInformation.dart';
import 'package:frcscouting3572/Models/User.dart';

class UserBloc extends ChangeNotifier {
  User _user = User(uuid: "", name: "", team: 0);

   ExtraUserInformation _extraUserInformation = ExtraUserInformation(uuid: "", event: Event(eventCode: "", name: "", startDate: "", endDate: ""), seasonDesc: "");
  ExtraUserInformation get extraUserInformation => _extraUserInformation;

  set extraUserInformation(ExtraUserInformation extraUserInformation) {
    _extraUserInformation = extraUserInformation;
    notifyListeners();
  }

  User get user => _user;


  set user(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserInitial(User user) {
    _user = user;
  }


}
