// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // importing secret url variables from secret.dart
// import 'secret.dart';
// import 'fakedata.dart';

// class AgilePlannerApp extends StatefulWidget {
//   @override
//   _AgilePlannerStateApp createState() => _AgilePlannerStateApp();
// }

// class _AgilePlannerStateApp extends State<AgilePlannerApp> {
//   var dayOfWeek = "Monday";
//   var counter = -6;

//   var schedule = {"Monday": [{"StartTimes": ["12", "13", "14", "17", "19"], "TaskNames": ["Morning Work", "Lunchtime", "Afternoon Work", "Evening Jog", "Playing Minecraft"], "Type": ["Work", "Leisure", "Work", "Exercise", "Leisure"]}]};

//   workOutDay(daysAfter){
//     var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
//     var now = new DateTime.now();
//     //-1 as we are indexing from a dictionary and in the DateTime class sunday = 7  but in dictionary sunday = 6
//     //+daysAfter to handle if someone scrolls through other days schedules
//     int weekday = now.weekday-1+daysAfter;
//     dayOfWeek = days[weekday];
//     return dayOfWeek;
//   }

//   goBack(){
//     print(counter);
//       dayOfWeek = workOutDay(counter);
//       setState(() {
//         if (counter == -6){
//         counter = 0;
//         } else{
//           counter --;
//         }
//       });
//       print("sent");
//   }

//   goForward(){
//       dayOfWeek = workOutDay(counter);
//       setState(() {
//         if (counter == 0){
//         counter = -6;
//         }else{
//           counter ++;
//         }
//       });
//       print(counter);
//       print("sent");
//   }

//   @override
//   Widget build(BuildContext context) {
//     List <Text> taskTimes = [];
//     List <Text> tasksList = [];
//     var taskInfo = schedule["Monday"];
//     for (var task in taskInfo){
//       taskTimes.add(Text(taskInfo["StartTimes"][task]));
//       tasksList.add(Text(task["TaskNames"]));
//     }
//     workOutDay(counter);
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(dayOfWeek),
//           backgroundColor: Colors.purple[500],
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               tooltip: 'Show Snackbar',
//               color: Colors.white,
//               onPressed: goBack,
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               tooltip: 'Show Snackbar',
//               color: Colors.white,
//               onPressed: goForward,
//             ),
//           ],
//         ),
//         body: Row(
//           children: <Widget>[
//             Row(
//               children: taskTimes,
//             ),
//             Row(
//               children: tasksList,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }