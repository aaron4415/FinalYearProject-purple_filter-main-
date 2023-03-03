import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:bordered_text/bordered_text.dart';

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
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: width / 100, color: Colors.blue),
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                pinch_sharp,
                color: Colors.white,
              ),
            ),
            BorderedText(
              strokeWidth: 4.0,
              strokeColor: Colors.blue,
              child: Text(
                'Distance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LinearPercentIndicator(
              width: width / 2,
              lineHeight: height / 32,
              percent: 0.4,
              progressColor: Colors.purpleAccent,
            ),
            BorderedText(
              strokeWidth: 4.0,
              strokeColor: Colors.blue,
              child: Text(
                '2cm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }
}
