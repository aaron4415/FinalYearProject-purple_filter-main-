import 'package:flutter/material.dart';

import 'package:bordered_text/bordered_text.dart';

const IconData coronavirus = IconData(0xe199, fontFamily: 'MaterialIcons');
const IconData brightnessHighOutlined =
    IconData(0xeefc, fontFamily: 'MaterialIcons');
const IconData coronavirusOutlined =
    IconData(0xef88, fontFamily: 'MaterialIcons');

Table displayTable(width, virusList) {
  Container virus1Icon = Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow()
        ]
      ),
      child: const Icon(
        coronavirus,
        color: Colors.white,
      ));

  BorderedText virus1Name = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[0],
          style: const TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold)));

  BorderedText virus1Percentage = BorderedText(
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

  Container virus2Icon = Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        brightnessHighOutlined,
        color: Colors.white,
      ));

  BorderedText virus2Name = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[1],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          )));

  BorderedText virus2Percentage = BorderedText(
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

  Container virus3Icon = Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        coronavirusOutlined,
        color: Colors.white,
      ));

  BorderedText virus3Name = BorderedText(
      strokeWidth: 4.0,
      strokeColor: Colors.blue,
      child: Text(virusList[2],
          style: const TextStyle(
              color: Colors.white,
              fontSize: 21.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold)));

  BorderedText virus3Percentage = BorderedText(
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
    0: FlexColumnWidth(width * 0.05),
    1: FlexColumnWidth(width * 0.35),
    2: FlexColumnWidth(width * 0.15)
  }, children: [
    TableRow(children: [virus1Icon, virus1Name, virus1Percentage]),
    TableRow(children: [virus2Icon, virus2Name, virus2Percentage]),
    TableRow(children: [virus3Icon, virus3Name, virus3Percentage])
  ]);
}