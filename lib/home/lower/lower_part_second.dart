import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:purple_filter/home/upper/upper_part.dart';


int pixelDifferencePercentage = 0;
double progressBarPercentage = 0.0;
double actualDistance = 0.0;
bool isDeviceMoving = false;

class LowerPartSecond extends StatefulWidget {
  LowerPartSecond({Key? key}) : super(key: key);

  @override
  State<LowerPartSecond> createState() => _LowerPartSecondState();
}

class _LowerPartSecondState extends State<LowerPartSecond> {
  IconData pinchSharp = const IconData(0xf0456, fontFamily: 'MaterialIcons');
  Sensors sensor = Sensors();
  late StreamSubscription<AccelerometerEvent> streamSubscription;

  @override
  void initState() {
    streamSubscription = sensor.accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        actualDistance;
        progressBarPercentage;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget pinchSharpIcon = Container(
        decoration: BoxDecoration(
            border: Border.all(width: width / 100, color: Colors.blue),
            color: Colors.blue,
            shape: BoxShape.circle),
        child: Icon(
          pinchSharp,
          color: Colors.white,
        )
    );

    Widget distanceText = BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: const Text(
            'Distance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )));

    Widget distanceIndicator = LinearPercentIndicator(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      barRadius: Radius.circular(10.0),
      width: width / 2.1,
      lineHeight: height / 50,
      percent: progressBarPercentage,
      backgroundColor: Colors.lightBlueAccent,
      progressColor: Colors.purpleAccent,
    );

    Widget distanceDisplay = BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: Text(
            '${actualDistance}cm',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )
        )
    );

    return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            pinchSharpIcon,
            distanceText, // It does nothing but to display the word "distance"
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0.0,
                    blurRadius: 10.0
                  ),
                  BoxShadow(
                    color: borderColor,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0.0,
                    blurRadius: 9.0
                  )
                ]
              ),
              child: distanceIndicator
            ), // Progress bar to show distance in graphic
            distanceDisplay // Text to display the realtime distance
          ],
        ));
  }
}
