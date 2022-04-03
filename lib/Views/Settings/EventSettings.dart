import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frcscouting3572/Constants.dart';
import 'package:frcscouting3572/Views/Shared/Snackbar.dart';
import 'package:intl/intl.dart';
import '../../Network/firstAPI.dart';
import '../../Network/db.dart';

class EventSettings extends StatefulWidget {
  const EventSettings({Key? key}) : super(key: key);

  @override
  _EventSettingsState createState() => _EventSettingsState();
}

class _EventSettingsState extends State<EventSettings> {
  int? season;
  String? district;
  dynamic selectedEvent;
  dynamic event;
  final GlobalKey<FormState> seasonKey = GlobalKey();

  TextEditingController seasonController = TextEditingController();
  List<dynamic> districts = [];
  @override
  void initState() {
    super.initState();
    initSeason();
  }

  initSeason() async {
    dynamic user = await getUserInformation();
    setState(() {
      if (user != null) {
        season = user["season"];
        seasonController.text = season.toString();
      } else {
        season = DateTime.now().year;
      }

      getDistrictsFromSeason(season).then((response) {
        setState(() {
          this.districts = response;
        });
      });
    });
  }

  checkSelectedEvent(event) {
    if (this.selectedEvent != null) {
      if (this.selectedEvent["code"] == event["code"]) {
        return Icon(Icons.check_box);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Settings"),
        actions: [
          TextButton(
              onPressed: () {
                if (this.selectedEvent != null && this.season != null) {
                  saveEventAndSeason(this.selectedEvent["code"], this.season!)
                      .then(
                    (value) {
                      showSnackBar(context, "Save successful", kGreen);
                    },
                    //Add error handlign?
                  ).onError((error, stackTrace) {
                    showSnackBar(context, "Save was unsuccessful: $error", kRed);
                  });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: screenSize.width / 2,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          value: this.district,
                          hint: Text("District"),
                          onChanged: (val) {
                            setState(() {
                              this.selectedEvent = null;
                              this.district = val;
                            });
                          },
                          items: districts.map<DropdownMenuItem>((value) {
                            var obj = jsonEncode(
                                {"name": value["name"], "code": value["code"]});
                            Map<String, dynamic> data = json.decode(obj);
                            return DropdownMenuItem(
                              value: obj,
                              child: Text(
                                data["name"],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          this.district = null;
                          this.selectedEvent = null;
                        });
                      },
                      child: Text("Clear Filter")),
                ],
              ),
              Divider(),
              if (season != null)
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: getEventsFromSeason(season, district),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic data = snapshot.data;
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              DateTime startDate =
                                  DateTime.parse(data[index]["dateStart"]);
                              DateTime endDate =
                                  DateTime.parse(data[index]["dateEnd"]);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    this.selectedEvent = data[index];
                                  });
                                },
                                child: ListTile(
                                  trailing: checkSelectedEvent(data[index]),
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        data[index]["name"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.fade),
                                      )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "${DateFormat.MMMEd().format(startDate)} - ${DateFormat.MMMEd().format(endDate)}",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return Center(
                          child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
