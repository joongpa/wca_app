import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';
import 'package:html/dom.dart' as dom;


class RSSList extends StatefulWidget {
  RSSList({Key key}) : super(key: key);

  @override
  RSSListState createState() => RSSListState();
}

class RSSListState extends State<RSSList> {
  static const String FEED_URL = 'https://www.worldcubeassociation.org/rss';
  static const String EMPTY = 'Nothing to show';
  RssFeed feed;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  Future<RssFeed> loadFeed() async {
    try {
      final response = await http.Client().get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {}
    return null;
  }

  updateFeed(feed) {
    setState(() {
      this.feed = feed;
    });
  }

  load() async {
    loadFeed().then((result) {
      updateFeed(result);
    });
  }

  Future<void> pullLoad() async {
    load();
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
//    print(database);
  }

  isFeedEmpty() {
    return feed == null || feed.toString().isEmpty;
  }

  title(title) {
    return Text(title,
        style: TextStyle(
            color: Colors.orange[900],
            fontSize: 20,
            fontWeight: FontWeight.bold));
  }

  subtitle(subtitle, expanded) {
    return Html(
      data: expanded ? subtitle : truncateWithEllipsis(300, subtitle),
      onLinkTap: _launchURL,
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  date(date) {
    return Text(
      date.replaceAll('+0000', ''),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey),
    );
  }

  showMore() {
    return Icon(
      Icons.keyboard_arrow_down,
      color: Colors.blue,
      size: 30.0,
    );
  }

  getExpandableCard(item) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ExpandableNotifier(
              // <-- Provides ExpandableController to its children
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expandable(
                    // <-- Driven by ExpandableController from ExpandableNotifier
                    collapsed: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          title(item.title),
                          SizedBox(height: 5),
                          date(item.pubDate),
                          subtitle(item.description, false),
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: ExpandableButton(
                              // <-- Collapses when tapped on
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                          )
                        ]),
                    expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          title(item.title),
                          SizedBox(height: 5),
                          date(item.pubDate),
                          subtitle(item.description, true),
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: ExpandableButton(
                              // <-- Collapses when tapped on
                              child: Icon(Icons.keyboard_arrow_up),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (isFeedEmpty())
      return CircularProgressIndicator();
    else
      return RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await pullLoad();
          },
          child: ListView.builder(
            itemCount: feed.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = feed.items[index];
              return getExpandableCard(item);
            },
          ));
  }
}