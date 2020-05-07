import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wcaapp/CompetitionDetailsPage.dart';
import 'package:wcaapp/CompetitionRepo.dart';
import 'package:wcaapp/DbProvider.dart';
import 'JSONModels/Competition.dart';
import 'Date.dart';

class CompetitionsPage extends StatefulWidget {
  CompetitionsPage({Key key}) : super(key: key);

  @override
  CompetitionsPageState createState() => CompetitionsPageState();
}

class CompetitionsPageState extends State<CompetitionsPage> {
  GlobalKey refreshKey;
  int pagesLoaded;
  ScrollController scrollController;
//  Future<List<Competition>> competitions;
  List<Competition> comps = List<Competition>();

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

//  static Future<List<Competition>> fetchCompetitions(String url) async {
//    final response = await http.get(url);
//    if(response.statusCode == 200) {
//      return compute(parseComps, response.body);
//    } else {
//      throw Exception('rip');
//    }
//  }
//
  void fetchNextPage(pageNumber) async {
    CompetitionRepo.cr.fetchCompetitions(pagesLoaded).then((result) {
      setState(() {
        comps += result;
      });
    });
  }

  Future<void> reload() async {
    pagesLoaded = 1;
    DbProvider.db.removeAll();
    load();
  }

  getDateText(date) {
    return Text(
      getDate(date),
      style: TextStyle(
          color: Colors.grey
      ),
    );
  }

  getCountryFlag(iso2Code){
    if(iso2Code.substring(0,1) == "X") return Icon(Icons.language);
    else return Image.asset('icons/flags/png/${iso2Code.toLowerCase()}.png', package: 'country_icons');
  }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    scrollController = ScrollController();
    load();
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        pagesLoaded++;
        fetchNextPage(pagesLoaded);
      }
    });
  }

  void load() async {
    CompetitionRepo.cr.competitions.then((result) {
      setState(() {
        comps = result;
      });
      pagesLoaded = comps.length ~/ 25;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  getListCard(index) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CompetitionDetailsPage(competition: comps[index],))
          );
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                      children: [
                        getCountryFlag(comps[index].countryIso2),
                        SizedBox(height: 10),
                        Text(comps[index].countryIso2,)
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
                        comps[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            color: ((comps[index].name.contains('Championship') && comps[index].competitorLimit >= 250) || (comps[index].competitorLimit != null && comps[index].competitorLimit >= 350))
                              ? Colors.deepOrange
                              : Colors.black,
                            fontWeight: ((comps[index].name.contains('Championship') && comps[index].competitorLimit >= 250) || (comps[index].competitorLimit != null && comps[index].competitorLimit >= 350))
                              ? FontWeight.bold
                              : FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 5),
                      getDateText(comps[index].startDate.toString()),
                      SizedBox(height: 6),
                      Text(comps[index].city)
                    ]
                ),
              ),
            ],
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(comps.length != 0) {
      return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          reload();
        },
        child: ListView.builder(
            controller: scrollController,
            itemCount: comps.length + 1,
            itemBuilder: (context, index) {
              if(index == comps.length) return Center(child:CircularProgressIndicator());
              return getListCard(index);
            }
        ),
      );
    } else return CircularProgressIndicator();

  }
}
