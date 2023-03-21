import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:simple_kalman/simple_kalman.dart';

import 'lower_part_first.dart';
import 'lower_part_second.dart';
import 'lower_part_third.dart';

class LowerPart extends StatefulWidget {
  LowerPart({Key? key}) : super(key: key);

  @override
  State<LowerPart> createState() => _LowerPartState();
}

class _LowerPartState extends State<LowerPart> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [LowerPartFirst(), LowerPartSecond(), const LowerPartThird()],
    );
  }
}
