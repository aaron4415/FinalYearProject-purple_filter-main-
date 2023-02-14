import 'package:flutter/material.dart';

import 'table_padding.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:bordered_text/bordered_text.dart';

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
            child: Row(children: [
          TableCell(
            child: BorderedText(
              strokeWidth: 4.0,
              strokeColor: Colors.blue,
              child: Text(
                'Covid-19',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TableCell(
              child: Icon(
            coronavirus,
            color: Colors.blue,
          )),
        ])),
        Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        )
      ]),
      TableRow(children: [
        TableCell(
            child: Row(children: [
          TableCell(
              child: BorderedText(
            strokeWidth: 4.0,
            strokeColor: Colors.blue,
            child: Text(
              'Coils',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          TableCell(
              child: Icon(
            brightness_high_outlined,
            color: Colors.blue,
          )),
        ])),
        Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        )
      ]),
      TableRow(children: [
        TableCell(
            child: Row(children: [
          TableCell(
              child: BorderedText(
            strokeWidth: 4.0,
            strokeColor: Colors.blue,
            child: Text(
              'Bacterial',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          TableCell(
              child: Icon(
            coronavirus_outlined,
            color: Colors.blue,
          )),
        ])),
        Text(
          '<99%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        )
      ]),
    ],
  );
}
//Coils Bacterial