import 'package:flutter/foundation.dart';

class MatchQueryBloc extends ChangeNotifier {
  String _searchText = "";
  String get searchText => _searchText;

  set searchText(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }


}
