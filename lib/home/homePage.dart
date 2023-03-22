import 'package:flutter/material.dart';

import 'dart:async';

import 'upper/upper_part.dart';
import 'lower/lower_part.dart';

int mainTime = 0;
bool redButtonLogic = false;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      updateMainTime();
    });
  }

  Future updateMainTime() async {
    setState(() {
      mainTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 1, 36),
        body: Column(
          children: [
            SizedBox(height: height / 2.1, child: UpperPart()),
            LowerPart()
          ],
        ));
  }
}
