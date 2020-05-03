import 'package:flutter/material.dart';
import 'popularTimes.dart';
import 'homePage.dart';
import 'covidNews.dart';
import 'voiceJournal.dart';
// agile planner is still in development
// import 'agilePlanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomeApp(),
    PopularTimes(),
    // agile planner is still in development
    // AgilePlannerApp(),
    CovidNewsApp(),
    JournalApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //place holder for showing an account page
  account(){
    print("account page");
  }

  //place holder for showing a settings page
  settings(){
    print("settings page");
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('CoWA',
          textAlign: TextAlign.center,),
          backgroundColor: Colors.blue[700],
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Show Snackbar',
              color: Colors.white,
              onPressed: account,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Show Snackbar',
              color: Colors.white,
              onPressed: settings,
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[700],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blueGrey),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public, color: Colors.blueGrey),
              title: Text('Popular Times'),
            ),
            // Agile Planner is still in development
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today, color: Colors.blueGrey),
            //   title: Text('Agile Planner'),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode, color: Colors.blueGrey),
              title: Text('News'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic, color: Colors.blueGrey),
              title: Text('Voice Journal'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}