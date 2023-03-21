import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
        width: width / 4 * 3,
        lineHeight: height / 32,
        percent: disinfectionPercentage / 100, /// TODO: Change this to a variable, the value should be identical to the disinfectionPercentage
        backgroundColor: Colors.lightBlue,
        progressColor: Colors.lightBlueAccent
    );
    return progressBar;
  }
}


