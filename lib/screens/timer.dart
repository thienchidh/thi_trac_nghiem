import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() {
    return new _TimerState();
  }
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    final now = time; // get time now from server
    final dDay = DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute + 1,
      time.second,
      time.millisecond,
      time.microsecond,
    ); // get time start from server

    final Duration _duration = dDay.difference(now);
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              height: 200,
            ),
          ),
          Center(
            child: Container(
              child: FlipClock.reverseCountdown(
                duration: _duration,
                digitColor: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
                backgroundColor: Theme.of(context).accentColor,
                digitSize: 40,
                flipDirection: FlipDirection.down,
                onDone: () {
                  print('_TimerState.build.onDone');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
