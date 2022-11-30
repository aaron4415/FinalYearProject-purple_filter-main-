import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LowerPartSecond extends StatefulWidget {
  const LowerPartSecond({Key? key}) : super(key: key);

  @override
  State<LowerPartSecond> createState() => _LowerPartSecondState();
}

const IconData pinch_sharp = IconData(0xf0456, fontFamily: 'MaterialIcons');

class _LowerPartSecondState extends State<LowerPartSecond> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Distance",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            const Icon(
              pinch_sharp,
              color: Colors.blue,
            ),
            LinearPercentIndicator(
              width: width / 2,
              lineHeight: height / 32,
              percent: 0.4,
              progressColor: Colors.purpleAccent,
            ),
            const Text(
              '2cm',
              style: TextStyle(
                color: Colors.blue,
              ),
            )
          ],
        ));
  }
}
