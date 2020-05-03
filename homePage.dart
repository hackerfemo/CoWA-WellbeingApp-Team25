import 'package:flutter/material.dart';
import 'popularTimes.dart';
import 'covidNews.dart';
import 'voiceJournal.dart';
import 'agilePlanner.dart';

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  //define these variables using variables declared in other pages to have a dynamic home screen
  static const _closest_park = 'Chilwell Park';
  static const _current_popularity = 'Busy';
  static const _latest_news = 'News Article 1';
  static const _current_task = 'Exercise';
  static const _current_task_time = '12:30 - 2:00';
  List <String> _pages = ['Current Popularity of $_closest_park', 'Latest News', '$_current_task', 'Record a Voice Journal Entry'];
  List <String> _page_descriptions = [_current_popularity, _latest_news, 'Record', _current_task_time];
  List <Icon> _icons = [Icon(Icons.public, size: 50), Icon(Icons.chrome_reader_mode, size: 50), Icon(Icons.mic, size: 50), Icon(Icons.calendar_today, size: 50)];

  double _volume = 0.0;

  @override
  Widget build(BuildContext context) {
    List <Card> _home_page_views = [];
    for (var _page in _pages){
      int index = _pages.indexOf(_page);
      _home_page_views.add(Card(
        child: ListTile(
          leading: _icons[index],
          title: Text(_page),
          subtitle: Text(_page_descriptions[index]),
          isThreeLine: true,
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            tooltip: 'Increase volume by 10',
            onPressed: () {
              setState(() {
                _volume += 10;
              });
            },
          )
        ),
      ));
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            children: _home_page_views,
          ),
        ) ,
      ),
    );
  }
}