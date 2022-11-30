import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:purple_filter/main.dart';

import 'camera_preview.dart';
import 'empty_container.dart';
import 'overlay_purple.dart';

// List<PurpleFilter> list = [
//   PurpleFilter(leftFactor: 1),
//   PurpleFilter(topFactor: -6, bottomFactor: 6, rightFactor: 1.5, leftFactor: 1.5,),
//   PurpleFilter(bottomFactor: -6, rightFactor: 1.5, topFactor: 6, leftFactor: 1.5),
//   PurpleFilter(leftFactor: -12),
//   PurpleFilter(rightFactor: -12)
// ];

List<PurpleFilter> list = [];

class UpperPart extends StatefulWidget {
  final int time;

  const UpperPart({Key? key, required this.time}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) { widget.time; });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CameraPreviewWidget(),
        redButtonLogic ? PurpleFilter.noPara() : const EmptyContainer(),
        for (PurpleFilter l in list) l
      ]
    );
  }
}