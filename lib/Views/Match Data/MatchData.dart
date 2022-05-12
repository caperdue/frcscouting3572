import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/blocs/MatchQueryBloc.dart';
//import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Views/Shared/CustomToggleButtons.dart';
import 'package:frcscouting3572/Views/Shared/EventSeasonBanner.dart';

import 'package:provider/provider.dart';

class MatchData extends StatefulWidget {
  MatchData();

  @override
  _MatchDataState createState() => _MatchDataState();
}

class _MatchDataState extends State<MatchData> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    List<bool> buttonState = [true, false];
    int viewSelection = 0;
      List<Widget> buttons = [
      Container(child: Text("Match")),
      Container(child: Text("All"))
    ];
    MatchQueryBloc matchQueryBloc = Provider.of<MatchQueryBloc>(context);
    return Column(
      children: <Widget>[
        EventSeasonBanner(),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CupertinoSearchTextField(
                  controller: searchController,
                  onChanged: (text) {
                    matchQueryBloc.searchText = text;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 25,
                  child: CustomToggleButtons(
                      buttonState: buttonState,
                      buttons: buttons,
                      initialValue: viewSelection,
                      initialEnabled: true,
                      onPressed: (int index) {
                        viewSelection = index;
                      }),
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
