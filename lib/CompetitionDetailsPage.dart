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

  String getLocalDate(venue, date) {
    String timezone = venue.timezone;
    return timeFormat.format(TZDateTime.from(date, getLocation(timezone)));
  }

  getSchedule() => FutureBuilder<Schedule>(
    future: schedule,
    builder: (context, snapshot){
      if(snapshot.hasData){
        return ListView.builder(
          itemCount: snapshot.data.venues[0].rooms[0].activities.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(getLocalDate(snapshot.data.venues[0], snapshot.data.venues[0].rooms[0].activities[index].startTime)),
              title: Text(snapshot.data.venues[0].rooms[0].activities[index].name)
            );
          }
        );
      } else {
        return CircularProgressIndicator();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.competition.name)),
      body: Center(
        child: getSchedule()
      ),
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
    activities: List<Activity>.from(json["activities"].map((x) => Activity.fromJson(x))),
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

  Activity({
    this.id,
    this.name,
    this.activityCode,
    this.startTime,
    this.endTime,
    this.childActivities,
    this.extensions,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    name: json["name"],
    activityCode: json["activityCode"],
    startTime: DateTime.parse(json["startTime"]),
    endTime: DateTime.parse(json["endTime"]),
    childActivities: List<Activity>.from(json["childActivities"].map((x) => Activity.fromJson(x))),
    extensions: List<ActivityExtension>.from(json["extensions"].map((x) => ActivityExtension.fromJson(x))),
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
