import 'package:flutter/foundation.dart';
import 'package:frcscouting3572/Models/ExtraUserInfo.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Network/DatabaseHandler.dart';

class UserBloc extends ChangeNotifier {
  User _user = User(uuid: "", name: "", team: 0);
  User get user => _user;

  ExtraUserInfo _extraUserInformation =
      ExtraUserInfo(uuid: "", eventName: "", startDate: "", endDate: "", seasonDesc: "");

  ExtraUserInfo get extraUserInfo => _extraUserInformation;

  set extraUserInfo(ExtraUserInfo extraUserInfo) {
    _extraUserInformation = extraUserInfo;

    dbHandler
        .getExtraUserInformation()
        .then((ExtraUserInfo? extraUserInformationFromCache) {
      if (extraUserInformationFromCache != null) {
        dbHandler.updateExtraUserInformation(extraUserInformationFromCache);
      } else {
        dbHandler.insertExtraUserInformation(extraUserInfo);
      }
      notifyListeners();
    });
  }

  set user(User user) {
    _user = user;
    //Update cache
    dbHandler.getUser().then((User? userFromCache) {
      if (userFromCache != null) {
        dbHandler.updateUser(userFromCache);
      } else {
        dbHandler.insertUser(user);
      }
      notifyListeners();
    });
  }

  Future setUserInitial(User user) async {
    _user = user;
    User? userFromCache = await dbHandler.getUser();
    if (userFromCache != null) {
      dbHandler.updateUser(userFromCache);
    } else {
      dbHandler.insertUser(user);
    }
  }

  Future<ExtraUserInfo?> initializeExtraUserInformation() async {
    ExtraUserInfo? userInfoFromCache =
        await dbHandler.getExtraUserInformation();
    if (userInfoFromCache != null) {
      this.extraUserInfo = userInfoFromCache;
      return userInfoFromCache;
    }
    return null;
  }
}
