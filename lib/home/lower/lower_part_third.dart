import 'package:flutter/material.dart';

import 'display_table.dart';

class LowerPartThird extends StatefulWidget {
  LowerPartThird({Key? key}) : super(key: key);

  @override
  State<LowerPartThird> createState() => _LowerPartThirdState();
}

class _LowerPartThirdState extends State<LowerPartThird> {
    IconData barChartSharp = const IconData(0xe7ca, fontFamily: 'MaterialIcons');

    @override
    Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;

        Widget tableTitleText = const Text(
            'Prediction disinfection level',
            style: TextStyle(color: Colors.blue)
        );

        Widget tableTitleIcon = Icon(
            barChartSharp,
            color: Colors.blue
        );

        Widget tableTitle = Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [tableTitleText, tableTitleIcon]
            )
        );

        Widget displayTableBox = Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 3 * 2),
                    child: displayTable(width)
                )
            )
        );

        return Center(
            child: Container(
                margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.rectangle
                ),
                child: Column(
                    children: [
                        tableTitle,
                        displayTableBox
                    ]
                )
            )
        );
    }
}
