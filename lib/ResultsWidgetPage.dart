import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'JSONModels/Records.dart';
import 'package:http/http.dart' as http;

Future<Records> fetchRecords() async {
  final response =
      await http.get('https://www.worldcubeassociation.org/api/v0/records');
  if (response.statusCode == 200) {
    return compute(recordsFromJson, response.body);
  } else
    throw Exception('Could not load records');
}

class ResultsWidgetPage extends StatefulWidget {
  @override
  _ResultsWidgetPageState createState() => _ResultsWidgetPageState();
}

class _ResultsWidgetPageState extends State<ResultsWidgetPage> {
  String currentRecordType;
  List recordTypes = [
    'World',
    'Africa',
    'Asia',
    'Europe',
    'North America',
    'South America',
    'Oceania'
  ];
  List<DropdownMenuItem<String>> dropDownMenuItems;
  Future<Records> futureRecords;

  Map<String, String> nameToValue = {'World': '_World'};

  @override
  void initState() {
    super.initState();
    dropDownMenuItems = getItems();
    currentRecordType = dropDownMenuItems[0].value;
    futureRecords = fetchRecords();
  }

  List<DropdownMenuItem<String>> getItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String recordType in recordTypes) {
      items.add(DropdownMenuItem(value: recordType, child: Text(recordType)));
    }
    return items;
  }

  void setSelection(String selectedRecordType) {
    setState(() {
      currentRecordType = selectedRecordType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            regionSelectionBox(),
            Expanded(
              child: FutureBuilder<Records>(
                future: futureRecords,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return recordList(snapshot, currentRecordType);
                  } else
                    return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ));
  }

  Widget regionSelectionBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 5.0,
            // has the effect of softening the shadow
            spreadRadius: 5.0,
            // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              1.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: DropdownButton(
          value: currentRecordType,
          items: dropDownMenuItems,
          onChanged: setSelection,
        ),
      ),
    );
  }

  Widget recordList(snapshot, currentlySelected) {
    switch (currentlySelected) {
      case 'World':
        return ListView(
          children: <Widget>[
            recordTile(snapshot.data.worldRecords.the333, "3x3"),
            recordTile(snapshot.data.worldRecords.the222, "2x2"),
            recordTile(snapshot.data.worldRecords.the444, "4x4"),
            recordTile(snapshot.data.worldRecords.the555, "5x5"),
            recordTile(snapshot.data.worldRecords.the666, "6x6"),
            recordTile(snapshot.data.worldRecords.the777, "7x7"),
            recordTile(snapshot.data.worldRecords.the333Bf, "3BL"),
            recordTile(snapshot.data.worldRecords.the333Fm, "FMC"),
            recordTile(snapshot.data.worldRecords.the333Oh, "OH"),
            recordTile(snapshot.data.worldRecords.clock, "CLK"),
            recordTile(snapshot.data.worldRecords.minx, "MGX"),
            recordTile(snapshot.data.worldRecords.pyram, "PYX"),
            recordTile(snapshot.data.worldRecords.skewb, "SKW"),
            recordTile(snapshot.data.worldRecords.sq1, "SQ1"),
            recordTile(snapshot.data.worldRecords.the444Bf, "4BL"),
            recordTile(snapshot.data.worldRecords.the555Bf, "5BL"),
            recordTile(snapshot.data.worldRecords.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'Africa':
        return ListView(
          children: <Widget>[
            recordTile(snapshot.data.continentalRecords.africa.the333, "3x3"),
            recordTile(snapshot.data.continentalRecords.africa.the222, "2x2"),
            recordTile(snapshot.data.continentalRecords.africa.the444, "4x4"),
            recordTile(snapshot.data.continentalRecords.africa.the555, "5x5"),
            recordTile(snapshot.data.continentalRecords.africa.the666, "6x6"),
            recordTile(snapshot.data.continentalRecords.africa.the777, "7x7"),
            recordTile(snapshot.data.continentalRecords.africa.the333Bf, "3BL"),
            recordTile(snapshot.data.continentalRecords.africa.the333Fm, "FMC"),
            recordTile(snapshot.data.continentalRecords.africa.the333Oh, "OH"),
            recordTile(snapshot.data.continentalRecords.africa.clock, "CLK"),
            recordTile(snapshot.data.continentalRecords.africa.minx, "MGX"),
            recordTile(snapshot.data.continentalRecords.africa.pyram, "PYX"),
            recordTile(snapshot.data.continentalRecords.africa.skewb, "SKW"),
            recordTile(snapshot.data.continentalRecords.africa.sq1, "SQ1"),
            recordTile(snapshot.data.continentalRecords.africa.the444Bf, "4BL"),
            recordTile(snapshot.data.continentalRecords.africa.the555Bf, "5BL"),
            recordTile(
                snapshot.data.continentalRecords.africa.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'Asia':
        return ListView(
          children: <Widget>[
            recordTile(snapshot.data.continentalRecords.asia.the333, "3x3"),
            recordTile(snapshot.data.continentalRecords.asia.the222, "2x2"),
            recordTile(snapshot.data.continentalRecords.asia.the444, "4x4"),
            recordTile(snapshot.data.continentalRecords.asia.the555, "5x5"),
            recordTile(snapshot.data.continentalRecords.asia.the666, "6x6"),
            recordTile(snapshot.data.continentalRecords.asia.the777, "7x7"),
            recordTile(snapshot.data.continentalRecords.asia.the333Bf, "3BL"),
            recordTile(snapshot.data.continentalRecords.asia.the333Fm, "FMC"),
            recordTile(snapshot.data.continentalRecords.asia.the333Oh, "OH"),
            recordTile(snapshot.data.continentalRecords.asia.clock, "CLK"),
            recordTile(snapshot.data.continentalRecords.asia.minx, "MGX"),
            recordTile(snapshot.data.continentalRecords.asia.pyram, "PYX"),
            recordTile(snapshot.data.continentalRecords.asia.skewb, "SKW"),
            recordTile(snapshot.data.continentalRecords.asia.sq1, "SQ1"),
            recordTile(snapshot.data.continentalRecords.asia.the444Bf, "4BL"),
            recordTile(snapshot.data.continentalRecords.asia.the555Bf, "5BL"),
            recordTile(snapshot.data.continentalRecords.asia.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'Europe':
        return ListView(
          children: <Widget>[
            recordTile(snapshot.data.continentalRecords.europe.the333, "3x3"),
            recordTile(snapshot.data.continentalRecords.europe.the222, "2x2"),
            recordTile(snapshot.data.continentalRecords.europe.the444, "4x4"),
            recordTile(snapshot.data.continentalRecords.europe.the555, "5x5"),
            recordTile(snapshot.data.continentalRecords.europe.the666, "6x6"),
            recordTile(snapshot.data.continentalRecords.europe.the777, "7x7"),
            recordTile(snapshot.data.continentalRecords.europe.the333Bf, "3BL"),
            recordTile(snapshot.data.continentalRecords.europe.the333Fm, "FMC"),
            recordTile(snapshot.data.continentalRecords.europe.the333Oh, "OH"),
            recordTile(snapshot.data.continentalRecords.europe.clock, "CLK"),
            recordTile(snapshot.data.continentalRecords.europe.minx, "MGX"),
            recordTile(snapshot.data.continentalRecords.europe.pyram, "PYX"),
            recordTile(snapshot.data.continentalRecords.europe.skewb, "SKW"),
            recordTile(snapshot.data.continentalRecords.europe.sq1, "SQ1"),
            recordTile(snapshot.data.continentalRecords.europe.the444Bf, "4BL"),
            recordTile(snapshot.data.continentalRecords.europe.the555Bf, "5BL"),
            recordTile(
                snapshot.data.continentalRecords.europe.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'North America':
        return ListView(
          children: <Widget>[
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the333, "3x3"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the222, "2x2"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the444, "4x4"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the555, "5x5"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the666, "6x6"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the777, "7x7"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the333Bf, "3BL"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the333Fm, "FMC"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the333Oh, "OH"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.clock, "CLK"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.minx, "MGX"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.pyram, "PYX"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.skewb, "SKW"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.sq1, "SQ1"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the444Bf, "4BL"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the555Bf, "5BL"),
            recordTile(
                snapshot.data.continentalRecords.northAmerica.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'South America':
        return ListView(
          children: <Widget>[
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the333, "3x3"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the222, "2x2"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the444, "4x4"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the555, "5x5"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the666, "6x6"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the777, "7x7"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the333Bf, "3BL"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the333Fm, "FMC"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the333Oh, "OH"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.clock, "CLK"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.minx, "MGX"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.pyram, "PYX"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.skewb, "SKW"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.sq1, "SQ1"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the444Bf, "4BL"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the555Bf, "5BL"),
            recordTile(
                snapshot.data.continentalRecords.southAmerica.the333Mbf, "MBL"),
          ],
        );
        break;
      case 'Oceania':
        return ListView(
          children: <Widget>[
            recordTile(snapshot.data.continentalRecords.oceania.the333, "3x3"),
            recordTile(snapshot.data.continentalRecords.oceania.the222, "2x2"),
            recordTile(snapshot.data.continentalRecords.oceania.the444, "4x4"),
            recordTile(snapshot.data.continentalRecords.oceania.the555, "5x5"),
            recordTile(snapshot.data.continentalRecords.oceania.the666, "6x6"),
            recordTile(snapshot.data.continentalRecords.oceania.the777, "7x7"),
            recordTile(
                snapshot.data.continentalRecords.oceania.the333Bf, "3BL"),
            recordTile(
                snapshot.data.continentalRecords.oceania.the333Fm, "FMC"),
            recordTile(snapshot.data.continentalRecords.oceania.the333Oh, "OH"),
            recordTile(snapshot.data.continentalRecords.oceania.clock, "CLK"),
            recordTile(snapshot.data.continentalRecords.oceania.minx, "MGX"),
            recordTile(snapshot.data.continentalRecords.oceania.pyram, "PYX"),
            recordTile(snapshot.data.continentalRecords.oceania.skewb, "SKW"),
            recordTile(snapshot.data.continentalRecords.oceania.sq1, "SQ1"),
            recordTile(
                snapshot.data.continentalRecords.oceania.the444Bf, "4BL"),
            recordTile(
                snapshot.data.continentalRecords.oceania.the555Bf, "5BL"),
            recordTile(
                snapshot.data.continentalRecords.oceania.the333Mbf, "MBL"),
          ],
        );
        break;
    }
  }

  Widget recordTile(recordBlock, title) {
    if (recordBlock is The222) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Single",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Average",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            getReadableTime(recordBlock.single),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            getReadableTime(recordBlock.average),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Single",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            getMultiResult(recordBlock.single),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
