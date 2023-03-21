import 'package:flutter/material.dart';

import 'package:bordered_text/bordered_text.dart';

const IconData coronavirus = IconData(0xe199, fontFamily: 'MaterialIcons');
const IconData brightnessHighOutlined =
    IconData(0xeefc, fontFamily: 'MaterialIcons');
const IconData coronavirusOutlined =
    IconData(0xef88, fontFamily: 'MaterialIcons');

Table displayTable(width, virusList) {
  Container covid19Icon = Container(
      decoration: BoxDecoration(
        border: Border.all(width: width / 200, color: Colors.blue),
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        coronavirus,
        color: Colors.white,
      ));

  BorderedText covid19Name = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[0],
          style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold)));

  BorderedText covid19Percentage = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: const Text('<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          )));

  Container coilsIcon = Container(
      decoration: BoxDecoration(
        border: Border.all(width: width / 200, color: Colors.blue),
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        brightnessHighOutlined,
        color: Colors.white,
      ));

  BorderedText coilsName = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[1],
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          )));

  BorderedText coilsPercentage = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: const Text('<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          )));

  Container bacterialIcon = Container(
      decoration: BoxDecoration(
        border: Border.all(width: width / 200, color: Colors.blue),
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        coronavirusOutlined,
        color: Colors.white,
      ));

  BorderedText bacterialName = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[2],
          style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold)));

  BorderedText bacterialPercentage = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: const Text('<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold)));

  return Table(columnWidths: {
    0: FlexColumnWidth(width / 150),
    1: FlexColumnWidth(width * 0.30),
    2: FlexColumnWidth(width * 0.20)
  }, children: [
    TableRow(children: [covid19Icon, covid19Name, covid19Percentage]),
    TableRow(children: [coilsIcon, coilsName, coilsPercentage]),
    TableRow(children: [bacterialIcon, bacterialName, bacterialPercentage])
  ]);
}
