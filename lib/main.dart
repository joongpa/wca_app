import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WCA',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.deepOrange[600],
      ),
      home: MyHomePage(title: 'WCA 0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: RSSList()
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), title: Text('Competitions')),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered_rtl),
              title: Text('Rankings')),
        ],
        onTap: onItemTapped,
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RSSList extends StatefulWidget {
  RSSList({Key key}) : super(key: key);

  @override
  RSSListState createState() => RSSListState();
}

class RSSListState extends State<RSSList> {
  static const String FEED_URL = 'https://www.worldcubeassociation.org/rss';
  static const String EMPTY = 'Nothing to show';
  RssFeed feed;

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

  @override
  void initState() {
    super.initState();
    load();
  }

  isFeedEmpty() {
    return feed == null || feed.toString().isEmpty;
  }

  subtitle(subtitle) {
    return Text(
      subtitle.replaceAll(RegExp(r'<.{0,5}>'),'').replaceAll('&#39;','\''),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }

  date(date) {
    return Text(
      date.replaceAll('+0000', ''),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isFeedEmpty()) return CircularProgressIndicator();
    else return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: feed.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = feed.items[index];
        return Padding(
          child: ListTile(
              title: Text(item.title),
              subtitle: date(item.pubDate),
              trailing: rightIcon()
              onTap: ,
          ),
          padding: EdgeInsets.symmetric(vertical: 5)
        );
      },
    );
  }
}
