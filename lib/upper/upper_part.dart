import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purple_filter/main.dart';

import 'camera_preview.dart';
import 'empty_container.dart';
import 'overlay_purple.dart';
import 'package:purple_filter/lower/red_button.dart' as globals;
// List<PurpleFilter> list = [
//   PurpleFilter(leftFactor: 1),
//   PurpleFilter(topFactor: -6, bottomFactor: 6, rightFactor: 1.5, leftFactor: 1.5,),
//   PurpleFilter(bottomFactor: -6, rightFactor: 1.5, topFactor: 6, leftFactor: 1.5),
//   PurpleFilter(leftFactor: -12),
//   PurpleFilter(rightFactor: -12)
// ];

List<PurpleFilter> list = [];
late AnimationController controller;
bool visible = false;

class UpperPart extends StatefulWidget {
  final int time;

  const UpperPart({Key? key, required this.time}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  // Animation
  late Animation<double> _animation =
      CurvedAnimation(parent: controller, curve: Curves.linear);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(children: [
      const CameraPreviewWidget(),
      Align(
        alignment: Alignment.center,
        child: Center(
          child: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            // The green box must be a child of the AnimatedOpacity widget.
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                height: height,
                width: width,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      redButtonLogic ? PurpleFilter.noPara() : const EmptyContainer(),
      for (PurpleFilter l in list) l
    ]);
  }
}
