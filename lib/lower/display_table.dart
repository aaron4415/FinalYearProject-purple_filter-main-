import 'package:flutter/material.dart';

import 'table_padding.dart';

const IconData coronavirus = IconData(0xe199, fontFamily: 'MaterialIcons');
const IconData brightness_high_outlined =
    IconData(0xeefc, fontFamily: 'MaterialIcons');
const IconData coronavirus_outlined =
    IconData(0xef88, fontFamily: 'MaterialIcons');
Table displayTable() {
  return Table(
    border: const TableBorder(
        verticalInside: BorderSide(width: 2.0, color: Colors.blue)),
    children: [
      TableRow(children: [
        TableCell(
            child: Row(children: const [
          TableCell(
              child: Text(
            'Covid-19',
            style: TextStyle(
              color: Colors.blue,
            ),
          )),
          TableCell(
              child: Icon(
            coronavirus,
            color: Colors.blue,
          )),
        ])),
        const Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
          ),
        )
      ]),
      TableRow(children: [
        TableCell(
            child: Row(children: const [
          TableCell(
              child: Text(
            'Coils',
            style: TextStyle(
              color: Colors.blue,
            ),
          )),
          TableCell(
              child: Icon(
            brightness_high_outlined,
            color: Colors.blue,
          )),
        ])),
        const Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
          ),
        )
      ]),
      TableRow(children: [
        TableCell(
            child: Row(children: const [
          TableCell(
              child: Text(
            'Bacterial',
            style: TextStyle(
              color: Colors.blue,
            ),
          )),
          TableCell(
              child: Icon(
            coronavirus_outlined,
            color: Colors.blue,
          )),
        ])),
        const Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
          ),
        )
      ]),
    ],
  );
}
//Coils Bacterial