import 'package:flutter/material.dart';

class ResultsWidgetPage extends StatelessWidget {

  final controller;

  ResultsWidgetPage({Key key, this.controller}) : super(key: key);

//  final controller = PageController(
//    keepPage: true,
//    initialPage: 0
//  );

  getRankingsPage() {
    return Column(
      children: <Widget>[

      ],
    );
  }

  getRecordsPage() {
    return Text(
      "hello"
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: [
        getRankingsPage(),
        getRecordsPage()
      ]
    );
  }
}