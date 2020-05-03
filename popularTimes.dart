import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
// importing secret url variables from secret.dart
import 'secret.dart';
import 'fakedata.dart';

class PopularTimes extends StatefulWidget {
  @override
  _PopularTimesState createState() => _PopularTimesState();
}

class _PopularTimesState extends State<PopularTimes> {
  // potential code for calling _getLocation() on page load up
  // @override
  // initState() {
  //   super.initState();
  //     _getLocation();
  // }
  int _park1_popularity;
  List currentPopularityData = [];

  _get_current_popularity(data){
    var now = new DateTime.now();
    //-1 as we are indexing from a dictionary and in the DateTime class sunday = 7  but in dictionary sunday = 6
    int weekday = now.weekday - 1;
    int hour = now.hour;
    var current_popularities = [];
    int current_popularity = 0;
    for (var item in data){
      if (item.containsKey('current_popularity')){
        current_popularity = item['current_popularity'];
      }else{
        var list_of_popular_times = item['populartimes'][weekday]['data'];
        current_popularity = list_of_popular_times[hour];
      };
      current_popularities.add({"name":item['name'], "popularity":current_popularity});
    };
    return current_popularities;
  }
  _getLocation() async {
    //gets user current location
    print("getting Location");
    Location location = new Location();
    
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData);
    var newLocation = CameraPosition(
      bearing: 192.8334901395799,
      // target: LatLng(_locationData.latitude, _locationData.longitude),
      target: LatLng(51.3900933, -0.0285187),
      tilt: 0,
      zoom: 12);
    // moves the map to the users location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newLocation));
    setState(() {
      _center = newLocation;
    });
  }

  _get_data_from_API(LatLng _top_left, LatLng _bottom_right) async {
    // popularTimesURL is the Url used to request the popular times data - found in secret.dart
    // var url = popularTimesURL;
    // var bodyData = {"tl": _top_left, "br": _bottom_right, "q": "park"};
    // var bodyString = json.encode(bodyData);
    // print(bodyString);
    // var response = await http.post(url, body: bodyString);
    // var data = response.body;
    // print(json.decode(data));
    // return json.decode(data);
    // this is some fake data to test with
    return bigDataset; 
  }

  // quick test to check all is configured for making requests
  _simple_Post_Test() async{
    var url = 'https://femi-test-server.glitch.me/messages';
    var response = await http.post(url, body: {'from': 'Femi', 'text': 'hi from flutter'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  // takes the park location data from the api's data
  _find_park_loc(data){ 
    var data_list = [];
    for (var item in data){
      data_list.add(LatLng(item['coordinates']["lat"], item['coordinates']["lng"]));
    }
    print(data_list);
    return data_list;
  }


  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition _center = CameraPosition(
    target: LatLng(45.521563, -122.677433),
    zoom: 14.5);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
      _getLocation();
  }

  // Know Good Lat Lng - yields 2 parks
  // LatLng(51.3494488,-0.0960801), LatLng(51.3689835,-0.0617154) 

  // this function adds the markers to the page, calls the api and extracts the data from the api
  void _add_markers() async{
    print("adding Markers");
    final GoogleMapController controller = await _controller.future;
    LatLngBounds viewCoords = await controller.getVisibleRegion();
    // had to set topLeft and BottomRight for api as controller.getVisibleRegion returns wrong corners - BottomLeft and TopRight
    LatLng topLeft = LatLng(viewCoords.northeast.latitude, viewCoords.southwest.longitude);
    LatLng bottomRight = LatLng(viewCoords.southwest.latitude, viewCoords.northeast.longitude);
    print('tl $topLeft');
    print('br $bottomRight');
    var api_data = await _get_data_from_API(topLeft, bottomRight);
    //To do: check error none in Thomas' output from API
    //api_data["error"]...
    List parkDataFromAPI = api_data["popularTimes"];
    var coordinateList = _find_park_loc(parkDataFromAPI);
    setState(() {
      currentPopularityData = _get_current_popularity(parkDataFromAPI);
      int _marker_num = 0;
      for (var coordinates in coordinateList){
        MarkerId current_marker_id = MarkerId("Park$_marker_num");
        final Marker marker = Marker(
          markerId: current_marker_id,
          position: coordinates,
        );
        _marker_num ++;
        markers[current_marker_id] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color busyColor;
    var veryBusyThresh = 75;
    var moderateBusyThresh = 60;
    List <Card> parkCards = [];
    for (var park in currentPopularityData){
      int popularity_displayer = park["popularity"];
      if (popularity_displayer >= veryBusyThresh){
        busyColor = Colors.red;
      } else if (popularity_displayer >= moderateBusyThresh){
        busyColor = Colors.amber;
      } else{
        busyColor = Colors.green;
      }
      parkCards.add(Card(
            child:ListTile(
              leading: Icon(Icons.album,
              color: busyColor),
                title: Text(park["name"]),
                subtitle: Text('Current Popularity is: $popularity_displayer'),
              ),
          //     ListTile (
          //       leading: Icon(Icons.album,
          //       color: busyColor)
          //     ),
          //   ],
          // ),
        ),
      );
    }
    return Scaffold(
      body: Container(
         // in logical pixels
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: _add_markers,
                child: Text(
                  "add markers"
                ),
              ),
              RaisedButton(
                onPressed: _getLocation,
                child: Text(
                  "get location"
                ),
              ),
              Container(
                height: 300,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _center, 
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              Expanded(              
                child: ListView(
                  children: parkCards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
