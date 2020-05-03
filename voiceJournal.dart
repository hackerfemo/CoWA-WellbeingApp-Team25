import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'secret.dart';

class JournalApp extends StatefulWidget {
  @override
  _JournalAppState createState() => _JournalAppState();
}

class _JournalAppState extends State<JournalApp> {

// start recording function - currently a place holder
_start_recording (){
  print("recording");
}

// stop recording function - currently a place holder
_stop_recording(){
  print("stopped recording");
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _start_recording,
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stop_recording,
              ),
            ],
          ),
        ),
      ),
    );
  }
}