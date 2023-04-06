import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [LowerPartFirst(), LowerPartSecond(), LowerPartThird()],
      // children: [const Center(
      //     child: Text(
      //         style: TextStyle(
      //             color: Colors.white
      //         ),
      //         "Testing")
      // ), LowerPartSecond(), LowerPartThird()],
    );
  }
}
