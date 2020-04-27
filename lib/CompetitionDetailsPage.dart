import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wcaapp/CompetitionsPage.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_2015-2025.dart' as tz;

class CompetitionDetailsPage extends StatefulWidget {
  final competition;
  CompetitionDetailsPage({Key key, @required this.competition}) : super(key: key) {
    tz.initializeTimeZones();
  }

  @override
  CompetitionDetailsPageState createState() => CompetitionDetailsPageState();
}

class CompetitionDetailsPageState extends State<CompetitionDetailsPage> {

  Future<Schedule> schedule;
  final timeFormat = DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    schedule = fetchSchedule(widget.competition.id);
  }

  String getLocalDate(timezone, date) {
    return timeFormat.format(TZDateTime.from(date, getLocation(timezone)));
  }

  int getHexToInt(String color) {
    final colorInt = int.parse('0xFF${color.substring(1)}');
    return colorInt;
  }

  getRoomLegendMap(snapshot) {
    var colorRoomPairs = [
      [],
      []
    ];
    for(int i = 0; i < snapshot.data.venues[0].rooms.length; i++) {
      colorRoomPairs[0].add(snapshot.data.venues[0].rooms[i].color);
      colorRoomPairs[1].add(snapshot.data.venues[0].rooms[i].name);
    }
    return colorRoomPairs;
  }

  getRoomLegend(snapshot) {
    final colorRoomPairs = getRoomLegendMap(snapshot);

    return Padding(
      padding: EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: List.generate(colorRoomPairs[0].length, (index) {
            return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size.square(20)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color(getHexToInt(colorRoomPairs[0][index]))
                      ),
                    ),
                  ),
                  Text(('  ${colorRoomPairs[1][index]}'.length < 50) ? '  ${colorRoomPairs[1][index]}' : '  ${colorRoomPairs[1][index].toString().substring(0, 50)}...',
                    style: TextStyle(
                    ),
                  ),
                ]
            );
          })
      )

    );
  }

  getEventEntry(snapshot, list, index, concurrent, [times]) {
    var occurrences = (times == null) ? 1 : times;
    var timezone = snapshot.data.venues[0].timezone;
    if(timezone == "Etc/UTC") timezone = "Europe/London";
    return ListTile(
        leading: (concurrent)
          ? Text(getLocalDate(timezone, list[index].startTime),
              style: TextStyle(
                color: Colors.transparent,
                fontSize: 15
              )
            )
          : Text(getLocalDate(timezone, list[index].startTime),
          style: TextStyle(
              fontSize: 15
          )
          ),
        title: Text(list[index].name,
          style: TextStyle(
            fontSize: 17
          )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(occurrences, (i) {
            return ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(20)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Color(getHexToInt(list[index + i].color))
                ),
              ),
            );
          })
        )
    );
  }


  splitByDay(List list, timezone) {
    var splits = [];
    var lastUnwanted = 0;
    for(int i = 1; i < list.length; i++) {
      if(
        TZDateTime.from(list[i].startTime, getLocation(timezone)).day !=
        TZDateTime.from(list[i-1].startTime, getLocation(timezone)).day
      ){
        splits.add(list.sublist(lastUnwanted, i));
        lastUnwanted = i;
      }
      if(i == list.length - 1) {
        splits.add(list.sublist(lastUnwanted, list.length));
      }
    }
    return splits;
  }

  getSchedule() => FutureBuilder<Schedule>(
    future: schedule,
    builder: (context, snapshot){
      if(snapshot.hasData){
        var list = [];
        for(int i = 0; i < snapshot.data.venues[0].rooms.length; i++)
          list += snapshot.data.venues[0].rooms[i].activities;
        list.sort((a, b) => a.startTime.compareTo(b.startTime));
        var timezone = snapshot.data.venues[0].timezone;
        if(timezone == "Etc/UTC") timezone = "Europe/London";
        //final list = snapshot.data.venues[0].rooms[0].activities;
        final listByDate = splitByDay(list, timezone);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getRoomLegend(snapshot),
            Divider(thickness: 5, height: 5,),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: listByDate.length,
                  separatorBuilder: (context, index) => SizedBox(height: 45),
                  itemBuilder: (context, index) {
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('${DateFormat('EEEE').format(TZDateTime.from(listByDate[index][0].startTime, getLocation(timezone)))}, ${getDate(TZDateTime.from(listByDate[index][0].startTime, getLocation(timezone)).toString())}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listByDate[index].length,
                              itemBuilder: (c, i) {
                                if(i < listByDate[index].length - 1) {
                                  if (listByDate[index][i].name == listByDate[index][i+1].name) {
                                    return getEventEntry(snapshot, listByDate[index], i, false, 2);
                                  }
                                }
                                if(i == 0) return getEventEntry(snapshot, listByDate[index], i, false);
                                if (concurrent(listByDate[index][i-1], listByDate[index][i])) {
                                  if(listByDate[index][i].name == listByDate[index][i-1].name) {
                                    return Container();
                                  }
                                  return getEventEntry(snapshot, listByDate[index], i, true);
                                }
                                return getEventEntry(snapshot, listByDate[index], i, false);
                              }
                          )
                        ]
                    );
                  }
              )
            )
          ]
        );
      } else {
        return Center(
          child: CircularProgressIndicator()
        );
      }
    },
  );

  bool concurrent(Activity a1, Activity a2) {
    return a1.startTime.isAtSameMomentAs(a2.startTime);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.competition.name)),
      body: getSchedule()
    );
  }
}

Future<Schedule> fetchSchedule(id) async {
  final response = await http.get('https://www.worldcubeassociation.org/api/v0/competitions/$id/schedule');
  if(response.statusCode == 200) {
    return Schedule.fromJson(json.decode(response.body));
  } else {
    throw Exception('rip');
  }
}
// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));

String scheduleToJson(Schedule data) => json.encode(data.toJson());

class Schedule {
  DateTime startDate;
  int numberOfDays;
  List<Venue> venues;

  Schedule({
    this.startDate,
    this.numberOfDays,
    this.venues,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    startDate: DateTime.parse(json["startDate"]),
    numberOfDays: json["numberOfDays"],
    venues: List<Venue>.from(json["venues"].map((x) => Venue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "numberOfDays": numberOfDays,
    "venues": List<dynamic>.from(venues.map((x) => x.toJson())),
  };
}

class Venue {
  int id;
  String name;
  int latitudeMicrodegrees;
  int longitudeMicrodegrees;
  String countryIso2;
  String timezone;
  List<Room> rooms;
  List<dynamic> extensions;

  Venue({
    this.id,
    this.name,
    this.latitudeMicrodegrees,
    this.longitudeMicrodegrees,
    this.countryIso2,
    this.timezone,
    this.rooms,
    this.extensions,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
    id: json["id"],
    name: json["name"],
    latitudeMicrodegrees: json["latitudeMicrodegrees"],
    longitudeMicrodegrees: json["longitudeMicrodegrees"],
    countryIso2: json["countryIso2"],
    timezone: json["timezone"],
    rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
    extensions: List<dynamic>.from(json["extensions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitudeMicrodegrees": latitudeMicrodegrees,
    "longitudeMicrodegrees": longitudeMicrodegrees,
    "countryIso2": countryIso2,
    "timezone": timezone,
    "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
    "extensions": List<dynamic>.from(extensions.map((x) => x)),
  };
}

class Room {
  int id;
  String name;
  String color;
  List<Activity> activities;
  List<RoomExtension> extensions;

  Room({
    this.id,
    this.name,
    this.color,
    this.activities,
    this.extensions,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    activities: List<Activity>.from(json["activities"].map((x) => Activity.fromJson(x, json["color"]))),
    extensions: List<RoomExtension>.from(json["extensions"].map((x) => RoomExtension.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color,
    "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
    "extensions": List<dynamic>.from(extensions.map((x) => x.toJson())),
  };
}

class Activity {
  int id;
  String name;
  String activityCode;
  DateTime startTime;
  DateTime endTime;
  List<Activity> childActivities;
  List<ActivityExtension> extensions;
  String color;

  Activity({
    this.id,
    this.name,
    this.activityCode,
    this.startTime,
    this.endTime,
    this.childActivities,
    this.extensions,
    this.color
  });

  factory Activity.fromJson(Map<String, dynamic> json, color) => Activity(
    id: json["id"],
    name: json["name"],
    activityCode: json["activityCode"],
    startTime: DateTime.parse(json["startTime"]),
    endTime: DateTime.parse(json["endTime"]),
    childActivities: List<Activity>.from(json["childActivities"].map((x) => Activity.fromJson(x, color))),
    extensions: List<ActivityExtension>.from(json["extensions"].map((x) => ActivityExtension.fromJson(x))),
    color: color
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "activityCode": activityCode,
    "startTime": startTime.toIso8601String(),
    "endTime": endTime.toIso8601String(),
    "childActivities": List<dynamic>.from(childActivities.map((x) => x.toJson())),
    "extensions": List<dynamic>.from(extensions.map((x) => x.toJson())),
  };
}

class ActivityExtension {
  Id id;
  String specUrl;
  PurpleData data;

  ActivityExtension({
    this.id,
    this.specUrl,
    this.data,
  });

  factory ActivityExtension.fromJson(Map<String, dynamic> json) => ActivityExtension(
    id: idValues.map[json["id"]],
    specUrl: json["specUrl"],
    data: PurpleData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": idValues.reverse[id],
    "specUrl": specUrl,
    "data": data.toJson(),
  };
}

class PurpleData {
  double capacity;
  int groups;
  int scramblers;
  int runners;
  bool assignJudges;

  PurpleData({
    this.capacity,
    this.groups,
    this.scramblers,
    this.runners,
    this.assignJudges,
  });

  factory PurpleData.fromJson(Map<String, dynamic> json) => PurpleData(
    capacity: json["capacity"].toDouble(),
    groups: json["groups"],
    scramblers: json["scramblers"],
    runners: json["runners"],
    assignJudges: json["assignJudges"],
  );

  Map<String, dynamic> toJson() => {
    "capacity": capacity,
    "groups": groups,
    "scramblers": scramblers,
    "runners": runners,
    "assignJudges": assignJudges,
  };
}

enum Id { GROUPIFIER_ACTIVITY_CONFIG }

final idValues = EnumValues({
  "groupifier.ActivityConfig": Id.GROUPIFIER_ACTIVITY_CONFIG
});

class RoomExtension {
  String id;
  String specUrl;
  FluffyData data;

  RoomExtension({
    this.id,
    this.specUrl,
    this.data,
  });

  factory RoomExtension.fromJson(Map<String, dynamic> json) => RoomExtension(
    id: json["id"],
    specUrl: json["specUrl"],
    data: FluffyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "specUrl": specUrl,
    "data": data.toJson(),
  };
}

class FluffyData {
  int stations;

  FluffyData({
    this.stations,
  });

  factory FluffyData.fromJson(Map<String, dynamic> json) => FluffyData(
    stations: json["stations"],
  );

  Map<String, dynamic> toJson() => {
    "stations": stations,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
