import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wcaapp/CompetitionsPage.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_2015-2025.dart' as tz;
import 'JSONModels/Schedule.dart';

class CompetitionDetailsPage extends StatefulWidget {
  final competition;

  CompetitionDetailsPage({Key key, @required this.competition})
      : super(key: key) {
    tz.initializeTimeZones();
  }

  @override
  _CompetitionDetailsPageState createState() => _CompetitionDetailsPageState();
}

class _CompetitionDetailsPageState extends State<CompetitionDetailsPage> {
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

  getRoomLegendMap(snapshot) {
    var colorRoomPairs = [[], []];
    for (int i = 0; i < snapshot.data.venues[0].rooms.length; i++) {
      colorRoomPairs[0].add(snapshot.data.venues[0].rooms[i].color);
      colorRoomPairs[1].add(snapshot.data.venues[0].rooms[i].name);
    }
    return colorRoomPairs;
  }

  getRoomLegend(snapshot) {
    final colorRoomPairs = getRoomLegendMap(snapshot);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              1.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(colorRoomPairs[0].length, (index) {
              return Row(mainAxisSize: MainAxisSize.min, children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(20)),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color(getHexToInt(colorRoomPairs[0][index]))),
                  ),
                ),
                Text(
                  ('  ${colorRoomPairs[1][index]}'.length < 50)
                      ? '  ${colorRoomPairs[1][index]}'
                      : '  ${colorRoomPairs[1][index].toString().substring(0, 50)}...',
                  style: TextStyle(),
                ),
              ]);
            })),
      ),
    );
  }

  getEventEntry(snapshot, list, index, concurrent, [times]) {
    var occurrences = (times == null) ? 1 : times;
    var timezone = snapshot.data.venues[0].timezone;
    if (timezone == "Etc/UTC") timezone = "Europe/London";
    return ListTile(
        leading: (concurrent)
            ? Text(getLocalDate(timezone, list[index].startTime),
                style: TextStyle(color: Colors.transparent, fontSize: 15))
            : Text(getLocalDate(timezone, list[index].startTime),
                style: TextStyle(fontSize: 15)),
        title: Text(list[index].name, style: TextStyle(fontSize: 17)),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(occurrences, (i) {
              return ConstrainedBox(
                constraints: BoxConstraints.tight(Size.square(20)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color(getHexToInt(list[index + i].color))),
                ),
              );
            })));
  }

  splitByDay(List list, timezone) {
    var splits = [];
    var lastUnwanted = 0;
    for (int i = 1; i < list.length; i++) {
      if (TZDateTime.from(list[i].startTime, getLocation(timezone)).day !=
          TZDateTime.from(list[i - 1].startTime, getLocation(timezone)).day) {
        splits.add(list.sublist(lastUnwanted, i));
        lastUnwanted = i;
      }
      if (i == list.length - 1) {
        splits.add(list.sublist(lastUnwanted, list.length));
      }
    }
    return splits;
  }

  List<dynamic> toListSeparatedByDay(data, timezone) {
    var list = [];
    for (int i = 0; i < data.venues[0].rooms.length; i++)
      list += data.venues[0].rooms[i].activities;
    list.sort((a, b) => a.startTime.compareTo(b.startTime));

    return splitByDay(list, timezone);
  }

  getSchedule() => FutureBuilder<Schedule>(
        future: schedule,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var timezone = snapshot.data.venues[0].timezone;
            if (timezone == "Etc/UTC") timezone = "Europe/London";

            final listByDate = toListSeparatedByDay(snapshot.data, timezone);

            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getRoomLegend(snapshot),
                  Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: listByDate.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 45),
                          itemBuilder: (context, index) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        '${DateFormat('EEEE').format(TZDateTime.from(listByDate[index][0].startTime, getLocation(timezone)))}, ${getDate(TZDateTime.from(listByDate[index][0].startTime, getLocation(timezone)).toString())}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: listByDate[index].length,
                                      itemBuilder: (c, i) {
                                        if (i < listByDate[index].length - 1) {
                                          if (listByDate[index][i].name ==
                                              listByDate[index][i + 1].name) {
                                            return getEventEntry(snapshot,
                                                listByDate[index], i, false, 2);
                                          }
                                        }
                                        if (i == 0)
                                          return getEventEntry(snapshot,
                                              listByDate[index], i, false);
                                        if (concurrent(listByDate[index][i - 1],
                                            listByDate[index][i])) {
                                          if (listByDate[index][i].name ==
                                              listByDate[index][i - 1].name) {
                                            return Container();
                                          }
                                          return getEventEntry(snapshot,
                                              listByDate[index], i, true);
                                        }
                                        return getEventEntry(snapshot,
                                            listByDate[index], i, false);
                                      })
                                ]);
                          }))
                ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text(widget.competition.name)),
        body: getSchedule());
  }
}

Future<Schedule> fetchSchedule(id) async {
  final response = await http.get(
      'https://www.worldcubeassociation.org/api/v0/competitions/$id/schedule');
  if (response.statusCode == 200) {
    return compute(scheduleFromJson, response.body);
  } else {
    throw Exception('rip');
  }
}

int getHexToInt(String color) {
  final colorInt = int.parse('0xFF${color.substring(1)}');
  return colorInt;
}

bool concurrent(Activity a1, Activity a2) {
  return a1.startTime.isAtSameMomentAs(a2.startTime);
}
