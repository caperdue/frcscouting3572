import 'package:flutter/material.dart';
import './PersonalScout.dart';
import 'package:flutter/cupertino.dart';
import '../Views/TeamCreation/TeamInitializer.dart';
import '../Constants.dart';

class Scout extends StatefulWidget {
  const Scout({Key? key}) : super(key: key);

  @override
  _ScoutState createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  bool global = false;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Container(
          color: kAquaMarine,
          width: screenWidth.width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Viewing data for GVSU Event 3/12 - 3/15", textAlign: TextAlign.center,),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth.width,
              child: ElevatedButton(
                style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(kNavy),
                  backgroundColor:  MaterialStateProperty.all(Colors.blue[300]),

    ),
                onPressed: () {
                  setState(() {
                    global = !global;
                  });
                },
                child: Text(
                  "Toggle ${global ? 'personal' : 'team'} view mode",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        if (!global)
          CupertinoSearchTextField(
            controller: searchController,
            onChanged: (search) {},
          ),
        if (!global) PersonalScout(),
        if (!global)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    showTeamInitializer(this.context);
                  }),
            ),
          )
      ],
    );
  }
}
