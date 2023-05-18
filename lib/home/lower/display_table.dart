import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';

import 'lower_part.dart';

const IconData virus1IconData = IconData(0xe199, fontFamily: 'MaterialIcons');
const IconData virus2IconData = IconData(0xeefc, fontFamily: 'MaterialIcons');
const IconData virus3IconData = IconData(0xef88, fontFamily: 'MaterialIcons');

double virus1Percentage = 0;
double virus2Percentage = 0;
double virus3Percentage = 0;

Table displayTable(width, virusList) {

  Container virus1Icon = Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow()
        ]
      ),
      child: const Icon(
        virus1IconData,
        color: Colors.white,
      ));

  Container virus1Name = Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: Text(virusList[0],
          style: textStyle))
  );

  Container virus1PercentageContainer = Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: virus1Percentage >= 100 ?Text("Done", style: textStyle) : Text('${virus1Percentage.ceil()}%', textAlign: TextAlign.center, style: textStyle)
      )
  );

  Container virus2Icon = Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      virus2IconData,
      color: Colors.white,
    ));

  Container virus2Name = Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: Text(virusList[1],
          style: textStyle))
  );

  Container virus2PercentageContainer = Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: virus2Percentage >= 100 ? Text("Done", style: textStyle) : Text('${virus2Percentage.ceil()}%', textAlign: TextAlign.center, style: textStyle)
    )
  );


  Container virus3Icon = Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      virus3IconData,
      color: Colors.white,
    )
  );

  Container virus3Name = Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(
        virusList[2],
        style: textStyle))
  );

  Container virus3PercentageContainer = Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: BorderedText(
        strokeWidth: 4.0,
        strokeColor: Colors.blue,
        child: virus3Percentage >= 100 ? Text("Done", style: textStyle) : Text('${virus3Percentage.ceil()}%', textAlign: TextAlign.center, style: textStyle)
      )
  );

  return Table(
    columnWidths: {
      0: FlexColumnWidth(width * 0.05),
      1: FlexColumnWidth(width * 0.35),
      2: FlexColumnWidth(width * 0.15)
    },
    children: [
      TableRow(children: [virus1Icon, virus1Name, virus1PercentageContainer]),
      TableRow(children: [virus2Icon, virus2Name, virus2PercentageContainer]),
      TableRow(children: [virus3Icon, virus3Name, virus3PercentageContainer])
    ]
  );
}