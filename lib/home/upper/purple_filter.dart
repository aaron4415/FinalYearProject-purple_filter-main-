import 'dart:async';

import 'package:flutter/material.dart';

import '../homePage.dart';

class PurpleFilter extends StatefulWidget {

  double topFactor = 1; double bottomFactor = 1; double leftFactor = 1; double rightFactor = 1;

  double condition = 0;

  PurpleFilter.noPara({Key? key}) : super(key: key);

  PurpleFilter({Key? key, this.condition = 0}) : super(key: key);

  @override
  State<PurpleFilter> createState() => _PurpleFilterState();
}

class _PurpleFilterState extends State<PurpleFilter> {
  late int level;

  Color ringColor = Colors.purple;
  Color lv1 = const Color(0xffcc00ff);
  Color lv2 = const Color(0xffad00d9);
  Color lv3 = const Color(0xff8b00ad);
  Color lv4 = const Color(0xff5c0073);
  Color lv5 = const Color(0xff350042);

  @override
  void initState() {
    super.initState();
    redButtonLogic ? Timer.periodic(const Duration(milliseconds: 500), (t) { updateLevel(); }) : null;
  }

  @override
  void dispose() { super.dispose(); }

  Future updateLevel() async {
    if (mounted) {
      setState(() {
        // level = mainTime;
        level = 0;
        switch (level) {
          case 1: ringColor = lv1; break;
          case 2: ringColor = lv2; break;
          case 3: ringColor = lv3; break;
          case 4: ringColor = lv4; break;
          case 5: ringColor = lv5; break;
          default: ringColor = Colors.purpleAccent; break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final difference = height / 2 - height / 2.2;
    //final difference = -1;

    if (widget.condition != 0) {
      if (widget.condition > 0) {
        //widget.rightFactor = -12 * widget.condition;
        widget.rightFactor = -12;
        widget.leftFactor = 1;
      }
      if (widget.condition < 0) {
        //widget.leftFactor = -12 * widget.condition;
        widget.leftFactor = -12;
        widget.rightFactor = 1;
      }
    }

    return Positioned(
      top: difference * widget.topFactor,
      bottom: difference * widget.bottomFactor,
      left: difference * widget.leftFactor,
      right: difference * widget.rightFactor,
      child: Container(
              margin: const EdgeInsets.all(10.0),
              height: height / 2.2,
              decoration: BoxDecoration(
                color: ringColor.withOpacity(0.6),
                shape: BoxShape.circle,
              )
      )
    );
  }
}



