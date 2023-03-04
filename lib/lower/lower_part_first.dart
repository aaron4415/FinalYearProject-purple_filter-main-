import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'disinfection_button.dart';
import 'package:bordered_text/bordered_text.dart';

const IconData coronavirus = IconData(0xe199, fontFamily: 'MaterialIcons');

class LowerPartFirst extends StatefulWidget {
  const LowerPartFirst({Key? key}) : super(key: key);

  @override
  State<LowerPartFirst> createState() => _LowerPartFirstState();
}

class _LowerPartFirstState extends State<LowerPartFirst> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget progressBar = LinearPercentIndicator(
      width: width / 4 * 3,
      lineHeight: height / 32,
      percent: 0.8,
      backgroundColor: Colors.lightBlue,
      progressColor: Colors.lightBlueAccent
    );

    Widget coronaVirusIcon = Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: width / 220, color: Colors.blue),
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        coronavirus,
        color: Colors.white,
      ),
    );

    Widget virusType = SizedBox(
        child: BorderedText(
          strokeWidth: 4.0,
          strokeColor: Colors.blue,
          child: const Text(
            'SARS-COV-2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );

    Widget disinfectPercentage = SizedBox(
        child: BorderedText(
            strokeWidth: 4.0,
            strokeColor: Colors.blue,
            child: const Text(
                '<75%',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                ),
            ),
        )
    );

    Widget upperFirstLeftPart = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width / 4 * 3),
        child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        coronaVirusIcon,
                        virusType
                      ]
                  ),
                  disinfectPercentage
                ]
            )
        )
    );

    return Row(
      children: [
        Column(children: [
            progressBar,
            upperFirstLeftPart // It contains the progress bar, the target virus and its icon, and the disinfection percentage
        ]),
          const DisinfectionButton()
      ],
    );
  }
}
