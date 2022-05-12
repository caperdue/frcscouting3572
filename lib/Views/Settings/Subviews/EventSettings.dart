import 'package:flutter/material.dart';
import 'package:frcscouting3572/Models/Event.dart';
import 'package:frcscouting3572/Models/ExtraUserInfo.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:frcscouting3572/Models/blocs/UserBloc.dart';
import 'package:frcscouting3572/Network/APIHelper.dart';
import 'package:frcscouting3572/Network/Auth.dart';
import 'package:frcscouting3572/Views/Shared/DialogMessage.dart';
import 'package:intl/intl.dart';
import 'package:frcscouting3572/Network/firstAPI.dart' as firstAPI;
import 'package:provider/provider.dart';

class EventSettings extends StatefulWidget {
  final User tempUser;
  EventSettings({required this.tempUser});

  @override
  _EventSettingsState createState() => _EventSettingsState();
}

class _EventSettingsState extends State<EventSettings> {
  int? season;
  String? selectedDistrict;
  String? selectedEventCode;
  Event? selectedEvent;
  final GlobalKey<FormState> seasonKey = GlobalKey();

  TextEditingController seasonController = TextEditingController();
  List<String> districts = [];
  @override
  void initState() {
    super.initState();
    this.season = widget.tempUser.season;
    seasonController.text = this.season.toString();
    if (widget.tempUser.eventCode != null)
      selectedEventCode = widget.tempUser.eventCode!;
    if (widget.tempUser.district != null)
      selectedDistrict = widget.tempUser.district!;
  }

  checkselectedEventCode(Event event) {
    if (this.selectedEventCode != null) {
      if (this.selectedEventCode == event.eventCode) {
        return Icon(Icons.check_box);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Settings"),
        actions: [
          TextButton(
              onPressed: () async {
                try {
                  if (this.selectedEventCode != null &&
                      this.season != null &&
                      this.selectedEvent != null) {
                    User tempUser = userBloc.user;
                    tempUser.season = this.season!;
                    tempUser.district = this.selectedDistrict;
                    tempUser.eventCode = this.selectedEventCode;

                    await apiHelper.post(
                        "Users/${auth.currentUser!.uid}/update", userBloc.user);
                    ExtraUserInfo tempUserInfo = userBloc.extraUserInfo;

                    tempUserInfo.seasonDesc =
                        await firstAPI.getSeasonInformation(this.season!);
                    tempUserInfo.uuid = userBloc.user.uuid;
                    tempUserInfo.eventName = this.selectedEvent!.name;
                    tempUserInfo.startDate = this.selectedEvent!.startDate;
                    tempUserInfo.endDate = this.selectedEvent!.endDate;
                    userBloc.extraUserInfo = tempUserInfo;

                    print(tempUserInfo.toJson());
                    userBloc.user = tempUser;

                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  showDialogMessage(context, "Error",
                      "There was an error updating user profile: $e");
                }
              },
              child: Text("Save"))
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: <Widget>[
                      Expanded(
                        child: Form(
                          key: seasonKey,
                          child: TextFormField(
                            onChanged: (text) {
                              if (seasonKey.currentState?.validate() == true) {
                                season = int.tryParse(seasonController.text);
                              }
                            },
                            validator: (text) {
                              var season = int.tryParse(seasonController.text);
                              if (season != null &&
                                  season > 2005 &&
                                  season <= DateTime.now().year) {
                                setState(() {});
                                return null;
                              }
                              setState(() {});
                              return "Invalid season input";
                            },
                            controller: seasonController,
                            decoration: InputDecoration(labelText: 'Season'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: firstAPI.getDistrictsBySeason(season!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var response = snapshot.data as List<dynamic>;
                        this.districts = List<String>.from(response);
                        if (this.selectedDistrict == null)
                          this.selectedDistrict = response[0];

                        return FutureBuilder(
                            future: firstAPI.getEventsByDistrictAndSeason(
                                season!, selectedDistrict!),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                var events = snapshot.data as List<Event>;
                                return Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            constraints: BoxConstraints(
                                              minWidth: screenSize.width / 2,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<dynamic>(
                                                value: this.selectedDistrict,
                                                hint: Text("String"),
                                                onChanged: (val) {
                                                  setState(() {
                                                    this.selectedDistrict = val;
                                                    print(
                                                        this.selectedDistrict);
                                                  });
                                                },
                                                items: districts
                                                    .map<DropdownMenuItem>(
                                                        (String district) {
                                                  return DropdownMenuItem(
                                                    value: district,
                                                    child: Text(district),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                      Divider(),
                                      if (season != null)
                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: events.length,
                                                itemBuilder: (context, index) {
                                                  DateTime startDate =
                                                      DateTime.parse(
                                                          events[index]
                                                              .startDate);
                                                  DateTime endDate =
                                                      DateTime.parse(
                                                          events[index]
                                                              .endDate);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        this.selectedEventCode =
                                                            events[index]
                                                                .eventCode;

                                                        this.selectedEvent =
                                                            events[index];
                                                      });
                                                    },
                                                    child: ListTile(
                                                      trailing:
                                                          checkselectedEventCode(
                                                              events[index]),
                                                      title: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                              child: Text(
                                                            events[index].name,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade),
                                                          )),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                              "${DateFormat.MMMEd().format(startDate)} - ${DateFormat.MMMEd().format(endDate)}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }))
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }));
                      }
                      return Container();
                    },
                  ),
                ],
              ))),
    );
  }
}
