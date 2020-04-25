import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:country_icons/country_icons.dart';

List<Competition> parseComps(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Competition>((json) => Competition.fromJson(json)).toList();
}

class Competition {
  String competitionClass;
  String url;
  String id;
  String name;
  String website;
  String shortName;
  String city;
  String venueAddress;
  String venueDetails;
  double latitudeDegrees;
  double longitudeDegrees;
  String countryIso2;
  DateTime startDate;
  DateTime registrationOpen;
  DateTime registrationClose;
  DateTime announcedAt;
  DateTime endDate;
  List<Delegate> delegates;
  List<Delegate> organizers;
  int competitorLimit;
  List<String> eventIds;

  Competition({
    this.competitionClass,
    this.url,
    this.id,
    this.name,
    this.website,
    this.shortName,
    this.city,
    this.venueAddress,
    this.venueDetails,
    this.latitudeDegrees,
    this.longitudeDegrees,
    this.countryIso2,
    this.startDate,
    this.registrationOpen,
    this.registrationClose,
    this.announcedAt,
    this.endDate,
    this.delegates,
    this.organizers,
    this.competitorLimit,
    this.eventIds,
  });

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
    competitionClass: json["class"],
    url: json["url"],
    id: json["id"],
    name: json["name"],
    website: json["website"],
    shortName: json["short_name"],
    city: json["city"],
    venueAddress: json["venue_address"],
    venueDetails: json["venue_details"],
    latitudeDegrees: json["latitude_degrees"].toDouble(),
    longitudeDegrees: json["longitude_degrees"].toDouble(),
    countryIso2: json["country_iso2"],
    startDate: DateTime.parse(json["start_date"]),
    registrationOpen: DateTime.parse(json["registration_open"]),
    registrationClose: DateTime.parse(json["registration_close"]),
    announcedAt: DateTime.parse(json["announced_at"]),
    endDate: DateTime.parse(json["end_date"]),
    delegates: List<Delegate>.from(json["delegates"].map((x) => Delegate.fromJson(x))),
    organizers: List<Delegate>.from(json["organizers"].map((x) => Delegate.fromJson(x))),
    competitorLimit: json["competitor_limit"],
    eventIds: List<String>.from(json["event_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "class": competitionClass,
    "url": url,
    "id": id,
    "name": name,
    "website": website,
    "short_name": shortName,
    "city": city,
    "venue_address": venueAddress,
    "venue_details": venueDetails,
    "latitude_degrees": latitudeDegrees,
    "longitude_degrees": longitudeDegrees,
    "country_iso2": countryIso2,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "registration_open": registrationOpen.toIso8601String(),
    "registration_close": registrationClose.toIso8601String(),
    "announced_at": announcedAt.toIso8601String(),
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "delegates": List<dynamic>.from(delegates.map((x) => x.toJson())),
    "organizers": List<dynamic>.from(organizers.map((x) => x.toJson())),
    "competitor_limit": competitorLimit,
    "event_ids": List<dynamic>.from(eventIds.map((x) => x)),
  };
}

class Delegate {
  String delegateClass;
  String url;
  int id;
  String wcaId;
  String name;
  String gender;
  String countryIso2;
  String delegateStatus;
  DateTime createdAt;
  DateTime updatedAt;
  List<Team> teams;
  Avatar avatar;
  String email;
  String region;
  int seniorDelegateId;

  Delegate({
    this.delegateClass,
    this.url,
    this.id,
    this.wcaId,
    this.name,
    this.gender,
    this.countryIso2,
    this.delegateStatus,
    this.createdAt,
    this.updatedAt,
    this.teams,
    this.avatar,
    this.email,
    this.region,
    this.seniorDelegateId,
  });

  factory Delegate.fromJson(Map<String, dynamic> json) => Delegate(
    delegateClass: json["class"],
    url: json["url"],
    id: json["id"],
    wcaId: json["wca_id"],
    name: json["name"],
    gender: json["gender"],
    countryIso2: json["country_iso2"],
    delegateStatus: json["delegate_status"] == null ? null : json["delegate_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    teams: List<Team>.from(json["teams"].map((x) => Team.fromJson(x))),
    avatar: Avatar.fromJson(json["avatar"]),
    email: json["email"] == null ? null : json["email"],
    region: json["region"] == null ? null : json["region"],
    seniorDelegateId: json["senior_delegate_id"] == null ? null : json["senior_delegate_id"],
  );

  Map<String, dynamic> toJson() => {
    "class": delegateClass,
    "url": url,
    "id": id,
    "wca_id": wcaId,
    "name": name,
    "gender": gender,
    "country_iso2": countryIso2,
    "delegate_status": delegateStatus == null ? null : delegateStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "teams": List<dynamic>.from(teams.map((x) => x.toJson())),
    "avatar": avatar.toJson(),
    "email": email == null ? null : email,
    "region": region == null ? null : region,
    "senior_delegate_id": seniorDelegateId == null ? null : seniorDelegateId,
  };
}

class Avatar {
  String url;
  String thumbUrl;
  bool isDefault;

  Avatar({
    this.url,
    this.thumbUrl,
    this.isDefault,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    url: json["url"],
    thumbUrl: json["thumb_url"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumb_url": thumbUrl,
    "is_default": isDefault,
  };
}

class Team {
  String friendlyId;
  bool leader;

  Team({
    this.friendlyId,
    this.leader,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    friendlyId: json["friendly_id"],
    leader: json["leader"],
  );

  Map<String, dynamic> toJson() => {
    "friendly_id": friendlyId,
    "leader": leader,
  };
}

class CompetitionsPage extends StatefulWidget {
  CompetitionsPage({Key key}) : super(key: key);

  @override
  CompetitionsPageState createState() => CompetitionsPageState();
}

class CompetitionsPageState extends State<CompetitionsPage> {
  int pagesLoaded;
  ScrollController scrollController;
  Future<List<Competition>> competitions;

  Future<List<Competition>> fetchCompetitions(String url) async {
    final response = await http.get(url);
    if(response.statusCode == 200) {
      return parseComps(response.body);
    } else {
      throw Exception('rip');
    }
  }

  fetchNext() async {

  }
//
//  load() async {
//    fetchCompetitions()
//      .then((result) {
//        setState(() {
//          competitions = result;
//        });
//    });
//  }

  getDate(date) {
    String dateText = date.replaceAll(r'00:00:00.000','');
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(5, 7));
    int day = int.parse(date.substring(8, 10));

    Map<int,String> months = {
      1:'January',
      2:'February',
      3:'March',
      4:'April',
      5:'May',
      6:'June',
      7:'July',
      8:'August',
      9:'September',
      10:'October',
      11:'November',
      12:'December',
    };

    return Text(
      '${months[month]} $day, $year',
      style: TextStyle(
        color: Colors.grey
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pagesLoaded = 0;
    scrollController = ScrollController();
    scrollController.addListener(() {
      //if(scrollController.position.pixels == scrollController.position.maxScrollExtent)

    });
    competitions = fetchCompetitions('https://www.worldcubeassociation.org/api/v0/competitions');
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Competition>>(
        future: competitions,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
                controller: scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Image.asset('icons/flags/png/${list[index].countryIso2.toLowerCase()}.png', package: 'country_icons'),
                                      SizedBox(height: 10),
                                      Text(list[index].countryIso2,)
                                    ]
                                  )
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                flex: 10,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        list[index].name,
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                      ),
                                      getDate(list[index].startDate.toString()),
                                      SizedBox(height: 6),
                                      Text(list[index].city)
                                    ]
                                ),
                              ),
                            ],
                          )
                      )
                  );
                }
            );
          }
          else return CircularProgressIndicator();
        }
    );
  }
}
