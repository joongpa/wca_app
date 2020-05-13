import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wcaapp/CompetitionDetailsPage.dart';
import 'package:wcaapp/CompetitionRepo.dart';
import 'package:wcaapp/DbProvider.dart';
import 'JSONModels/Competition.dart';
import 'Date.dart';

class CompetitionsPage extends StatefulWidget {
  List<Competition> _comps = List<Competition>();

  CompetitionsPage({Key key}) : super(key: key);

  @override
  CompetitionsPageState createState() => CompetitionsPageState();
}

class CompetitionsPageState extends State<CompetitionsPage> with AutomaticKeepAliveClientMixin<CompetitionsPage> {
  GlobalKey refreshKey;
  int pagesLoaded;
  ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  void fetchNextPage(pageNumber) async {
    CompetitionRepo.cr.fetchCompetitions(pagesLoaded).then((result) {
      setState(() {
        widget._comps += result;
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
    pagesLoaded = widget._comps.length ~/ 25;
    refreshKey = GlobalKey<RefreshIndicatorState>();
    scrollController = ScrollController();
    if(widget._comps.length == 0)load();
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        pagesLoaded++;
        fetchNextPage(pagesLoaded);
      }
    });
    super.initState();
  }

  void load() async {
    CompetitionRepo.cr.competitions.then((result) {
      setState(() {
        widget._comps = result;
      });
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
            MaterialPageRoute(builder: (context) => CompetitionDetailsPage(competition: widget._comps[index],))
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
                        getCountryFlag(widget._comps[index].countryIso2),
                        SizedBox(height: 10),
                        Text(widget._comps[index].countryIso2,)
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
                        widget._comps[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            color: ((widget._comps[index].name.contains('Championship') && widget._comps[index].competitorLimit >= 250) || (widget._comps[index].competitorLimit != null && widget._comps[index].competitorLimit >= 350))
                              ? Colors.deepOrange
                              : Colors.black,
                            fontWeight: ((widget._comps[index].name.contains('Championship') && widget._comps[index].competitorLimit >= 250) || (widget._comps[index].competitorLimit != null && widget._comps[index].competitorLimit >= 350))
                              ? FontWeight.bold
                              : FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 5),
                      getDateText(widget._comps[index].startDate.toString()),
                      SizedBox(height: 6),
                      Text(widget._comps[index].city)
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
    super.build(context);
    if(widget._comps.length != 0) {
      return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          reload();
        },
        child: ListView.builder(
            controller: scrollController,
            itemCount: widget._comps.length + 1,
            itemBuilder: (context, index) {
              if(index == widget._comps.length) return Center(child:CircularProgressIndicator());
              return getListCard(index);
            }
        ),
      );
    } else return CircularProgressIndicator();

  }
}
