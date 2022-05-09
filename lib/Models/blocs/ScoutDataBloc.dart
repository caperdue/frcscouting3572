import 'package:flutter/foundation.dart';
import 'package:frcscouting3572/Models/ScoutTeam.dart';

class ScoutDataBloc extends ChangeNotifier {
  List<ScoutTeam> _scoutDataList = [];

  List<ScoutTeam> get scoutDataList => _scoutDataList;

  set scoutDataList(List<ScoutTeam> scoutDataList) {
    _scoutDataList = scoutDataList;
    notifyListeners();
  }

  void add(ScoutTeam scoutData) {
    _scoutDataList.add(scoutData);
    notifyListeners();
  }

  void remove(ScoutTeam scoutData) {
    _scoutDataList.remove(scoutData);
    notifyListeners();
  }

  void edit(ScoutTeam scoutTeam) {
    ScoutTeam dataFromList = _scoutDataList.lastWhere((ScoutTeam scoutData) {
      return scoutData == scoutTeam;
    });
    _scoutDataList.remove(dataFromList);
    _scoutDataList.add(scoutTeam);

    notifyListeners();
  }
}
