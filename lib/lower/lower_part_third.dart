import 'package:flutter/material.dart';

import 'display_table.dart';

const IconData bar_chart_sharp = IconData(0xe7ca, fontFamily: 'MaterialIcons');

class LowerPartThird extends StatefulWidget {
  const LowerPartThird({Key? key}) : super(key: key);

  @override
  State<LowerPartThird> createState() => _LowerPartThirdState();
}

class _LowerPartThirdState extends State<LowerPartThird> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
        child: Container(
            margin: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 4.0, bottom: 4.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.rectangle),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Prediction disinfection level',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          bar_chart_sharp,
                          color: Colors.blue,
                        ),
                      ]),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: width / 3 * 2),
                            child: displayTable(width))))
              ],
            )));
  }
}
