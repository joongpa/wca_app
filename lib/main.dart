import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wcaapp/CompetitionsPage.dart';
import 'package:wcaapp/DbProvider.dart';
import 'package:wcaapp/ResultsWidgetPage.dart';
import 'package:path/path.dart';

//Todo
//Double tap to expand/collapse

import 'RSSList.dart';

Future<void> main() async => runApp(MyApp());

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
        primaryColor: Colors.white,
        textSelectionColor: Colors.deepOrange,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  String title = 'Home';
  final controller = PageController(initialPage: 0, keepPage: true);

  final bucket = PageStorageBucket();

  List<Widget> widgetList = <Widget>[
    RSSList(key: PageStorageKey('page1')),
    CompetitionsPage(key: PageStorageKey('page2')),
    ResultsWidgetPage()
  ];

  List<String> pageTitles = <String>[
    'Home',
    'Competitions',
    'Results'
  ];


  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      title = pageTitles[index];
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

        title: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Center(child: widgetList[selectedIndex]),
      bottomNavigationBar: PageStorage(
        bucket: bucket,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance), title: Text('Competitions')),
            BottomNavigationBarItem(
                icon: Icon(Icons.format_list_numbered_rtl),
                title: Text('Results')),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: onItemTapped,
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).textSelectionColor,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
