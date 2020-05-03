import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'secret.dart';

class CovidNewsApp extends StatefulWidget {
  @override
  _CovidNewsAppState createState() => _CovidNewsAppState();
}

class _CovidNewsAppState extends State<CovidNewsApp> {
  // fake data to test the app with and reduce use of API key
  //var _newsArticles = [{'title': 'Article 1', 'description': 'Article 1 was just created', 'link':'https://hackerfemo.com'}, {'title': 'Article 2', 'description': 'Article 2 was just created', 'link':'https://hackerfemo.com/portfolio'}];
  var _state = "";
  int pageNumber = 1;
  var typeOfNews = "Showing Covid News";
  var _resp_userId = "";
  var _resp_id = "";
  var _resp_title = "";
  var _article_titles = ['Title 1', 'Title 2'];
  var _article_descriptions = ['Description 1', 'Description 2'];
  var _article_links = ['Link1', 'Link 2'];
  int _toggle = 0;
  var _article_data = [];

  _getNextPageOfNonCovidNews() async{
    // var fakeData = {"error": "None", "attribution": "Powered by NewsAPI.org", "news": [{"source": "bbc-news", "title": "2020/04/10 21:00 GMT", "description": "The latest five minute news bulletin from BBC World Service.", "url": "https://www.bbc.co.uk/programmes/w172x5nqr5zywy2"}, {"source": "bbc-news", "title": "2020/04/11 00:00 GMT", "description": "The latest five minute news bulletin from BBC World Service.", "url": "https://www.bbc.co.uk/programmes/w172x5nqr5zz85g"}]};
    var random = new Random();
    var url = nonCovidNewsURL;
    var encodedBody = json.encode({'page': pageNumber});
    var response = await http.post(url, body: encodedBody);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(pageNumber);
    if (this.mounted){
    setState(() {
        var _decoded_data = json.decode(response.body);
        _article_data.addAll(_decoded_data['news']);
        _state = " ";
        if (pageNumber == 10){
          pageNumber = 1;
        }else{
          pageNumber++;
        }
      });
    }
  }

  _getCovidNews() async{
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(covidNewsURL);
    if (response.statusCode == 200) {
      setState(() {
        var _decoded_data = json.decode(response.body);
        _article_data = _decoded_data['news'];
      });
    } else {
      //alert error on phone
      print('Request failed with status: ${response.statusCode}.');
    }
    _state = " ";
  }

  decideTypeOfNews() {
    setState(() {
      _state = "loading";
    });
    if (_toggle == 0){
      _getCovidNews();
    }else{
      _getNextPageOfNonCovidNews();
    }
  }

  toggleNews() async{
    setState((){
      if (_toggle == 0){
        _toggle = 1;
        typeOfNews = "Showing Non-Covid News";
      }else {
        _toggle = 0;
        typeOfNews = "Showing Covid News";
      }
    });
    print(typeOfNews);
  }

  // enables user to visit links from our app
  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  

  @override
  Widget build(BuildContext context) {
    List<Card> _cardList = [];
    for (var article in _article_data){
      _cardList.add(Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.new_releases),
              title: Text(article['title']),
              subtitle: Text(article['description']),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: () {launchURL(article['url']);},
                  child: Icon(Icons.link),
                ),
              ],
            )
          ],
        ),
      ));
    }
    _cardList.add(
    Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                onPressed: toggleNews,
                child: Text(typeOfNews),
              ),
              Text(
                _state,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ),
    );
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView(
            children: _cardList,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: decideTypeOfNews,
          label: Text("Load More Articles"),
          icon: Icon(Icons.refresh),
          backgroundColor: Colors.blue,
        ),
      ),

    );
  }
}