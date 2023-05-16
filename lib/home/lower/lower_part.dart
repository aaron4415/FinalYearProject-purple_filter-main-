import 'package:flutter/material.dart';

import 'lower_part_first.dart';
import 'lower_part_second.dart';
import 'lower_part_third.dart';

TextStyle textStyle = const TextStyle( color: Colors.white, fontSize: 21.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

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
    );
  }
}
