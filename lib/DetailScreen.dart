import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final item;
  DetailScreen({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(item.title)),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  Text(item.pubDate.replaceAll('+0000', ''), textAlign: TextAlign.left),
                  Text(item.description),
                ]))));
  }
}
