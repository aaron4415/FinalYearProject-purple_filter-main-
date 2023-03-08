import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:bordered_text/bordered_text.dart';

import 'disinfection_button.dart';

class LowerPartSecond extends StatefulWidget {
    const LowerPartSecond({Key? key}) : super(key: key);

    @override
    State<LowerPartSecond> createState() => _LowerPartSecondState();
}

class _LowerPartSecondState extends State<LowerPartSecond> {
    IconData pinchSharp = const IconData(0xf0456, fontFamily: 'MaterialIcons');

    @override
    Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        Widget pinchSharpIcon = Container(
            decoration: BoxDecoration(
                border: Border.all(width: width / 100, color: Colors.blue),
                color: Colors.blue,
                shape: BoxShape.circle
            ),
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
                )
            )
        );

        Widget distanceIndicator = LinearPercentIndicator(
              width: width / 2,
              lineHeight: height / 32,
              percent: 0.4, // TODO: The merge function should link to here, need a variable to hold the pixel value and translate to distance
              progressColor: Colors.purpleAccent,
        );

        Widget distanceDisplay = BorderedText(
            strokeWidth: 4.0,
            strokeColor: Colors.blue,
            child: Text(
                  '$imgData', // TODO: Change this to a variable and changes as the distanceIndicator
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
              )
            )
        );

        return Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  pinchSharpIcon,
                  distanceText, // It does nothing but to display the word "distance"
                  distanceIndicator, // Progress bar to show distance in graphic
                  distanceDisplay // Text to display the realtime distance
              ],
            )
        );
    }
}