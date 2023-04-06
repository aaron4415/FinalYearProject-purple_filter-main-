import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:simple_kalman/simple_kalman.dart';

import 'package:purple_filter/home/lower/disinfection_button.dart';
import 'package:purple_filter/home/lower/custom_percentage_indicator.dart';

int disinfectionPercentage = 0;
late StreamSubscription<GyroscopeEvent> listener;

class LowerPartFirst extends StatefulWidget {
  LowerPartFirst({Key? key}) : super(key: key);

  @override
  State<LowerPartFirst> createState() => _LowerPartFirstState();
}

class _LowerPartFirstState extends State<LowerPartFirst> {
  IconData coronavirus = const IconData(0xe199, fontFamily: 'MaterialIcons');

  Sensors sensor = Sensors();
  List<double> filteredAcceleration = [];
  List<double> filteredGyroscope = [];
  double nonZeroGyroscopeDataPercentage = 0;

  @override
  void initState() {
    super.initState();
    listener = sensor.gyroscopeEvents.listen((GyroscopeEvent event) {
      double combinedXYZ =
          event.z * event.z + event.y * event.y + event.x * event.x;
      final gyroscopeFilter =
          SimpleKalman(errorMeasure: 512, errorEstimate: 120, q: 0.5);
      double gyroscopeData = gyroscopeFilter.filtered(combinedXYZ);
      gyroscopeData = gyroscopeData < 0.0005 ? 0 : gyroscopeData;
      setState(() {
        if (gyroscopeData != 0) {
          disinfectionPercentage = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget coronaVirusIcon = Container(
        decoration: BoxDecoration(
          border: Border.all(width: width / 220, color: Colors.blue),
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Icon(coronavirus, color: Colors.white));

    Widget virusType = SizedBox(
        child: BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: const Text(
        'SARS-COV-2',

        /// TODO: Change this to a variable that allows users to choose which target virus to disinfect
        style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
    ));

    Widget disinfectPercentage = BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: Text(
            '$disinfectionPercentage %', // TODO: Change this to a double variable that changes the number as progress continues
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )));

    Widget upperFirstLeftPart = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width / 4 * 3),
        child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [coronaVirusIcon, virusType]),
                  disinfectPercentage
                ])));

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
              children: [
                CustomPercentageIndicator(),
                upperFirstLeftPart // It contains the progress bar, the target virus and its icon, and the disinfection percentage
              ]
          )
        ),
        DisinfectionButton()
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor:  Colors.blue ,
        //     shape: const CircleBorder(),
        //     maximumSize: Size(width / 5.5, height / 6.5),
        //     side: const BorderSide(color: Colors.white, width: 5),
        //   ),
        //   child: null,
        // )
      ],
    );
  }
}
