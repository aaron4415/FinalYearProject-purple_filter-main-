import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'red_button.dart';

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

    return Row(
      children: [
        Column(children: [
          LinearPercentIndicator(
              width: width / 4 * 3,
              lineHeight: height / 32,
              percent: 0.8,
              backgroundColor: Colors.lightBlue,
              progressColor: Colors.lightBlueAccent),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width / 4 * 3),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          SizedBox(
                              child: Text(
                            'SARS-COV-2',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )),
                          Icon(
                            coronavirus,
                            color: Colors.blue,
                          ),
                        ]),
                        const SizedBox(
                            child: Text(
                          '<75%',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                      ])))
        ]),
        RedButton()
      ],
    );
  }
}
