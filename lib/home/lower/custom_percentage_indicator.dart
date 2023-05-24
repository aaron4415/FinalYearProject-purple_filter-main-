import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:purple_filter/home/upper/upper_part.dart';

import 'lower_part_first.dart';

class CustomPercentageIndicator extends StatefulWidget {
  const CustomPercentageIndicator({Key? key}) : super(key: key);

  @override
  State<CustomPercentageIndicator> createState() => _CustomPercentageIndicatorState();
}

class _CustomPercentageIndicatorState extends State<CustomPercentageIndicator> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    LinearPercentIndicator progressBar = LinearPercentIndicator(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        width: width / 4 * 3,
        lineHeight: height / 40,
        percent: disinfectionPercentage / 100, /// TODO: Change this to a variable, the value should be identical to the disinfectionPercentage
        // backgroundColor: Color.fromARGB(255, 138, 43, 226),
        backgroundColor: Colors.white,
        barRadius: Radius.circular(10.0),
        linearGradient: LinearGradient(
          colors: [blueColor, redColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
    ),
    );
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0.5,
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
      child: progressBar
    );
  }
}


