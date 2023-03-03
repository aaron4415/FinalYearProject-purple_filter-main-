import 'package:flutter/material.dart';

import 'menu_button.dart';
import 'lower_part_first.dart';
import 'lower_part_second.dart';
import 'lower_part_third.dart';

class LowerPart extends StatefulWidget {
  const LowerPart({Key? key}) : super(key: key);

  @override
  State<LowerPart> createState() => _LowerPartState();
}

class _LowerPartState extends State<LowerPart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LowerPartFirst(),
        LowerPartSecond(),
        LowerPartThird(),
        //MenuButton()
      ],
    );
  }
}
