import 'package:flutter/material.dart';

import 'camera_preview.dart';
import 'purple_filter.dart';

List<PurpleFilter> list = [];
late AnimationController controller;
Color borderColor = Color.fromARGB(200, 50, 50, 237);
Color blueColor = Color.fromARGB(200, 50, 50, 237);
Color redColor = Color.fromARGB(200, 237, 50, 50);

class UpperPart extends StatefulWidget {
  const UpperPart({Key? key}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double borderWidth = width / 20;

    return Container(
      // padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: borderColor,
            // color: Color.fromARGB(200, 237, 50, 50), // previously a = 130
            // color: Color.fromARGB(200, 50, 50, 237),
            spreadRadius: 6,
            blurRadius: 12
          )
        ]
      ),
      child: const CameraPreviewWidget(),
    );
    // return Stack(children: [
    //   const CameraPreviewWidget(),
    //   Align(
    //     alignment: Alignment.center,
    //     child: Center(
    //       // The green box must be a child of the AnimatedOpacity widget.
    //       child: Container(
    //         decoration: BoxDecoration(
    //           border: Border(
    //             top: BorderSide(width: borderWidth, color: borderColor),
    //             bottom: BorderSide(width: borderWidth, color: borderColor),
    //             left: BorderSide(width: borderWidth, color: borderColor),
    //             right: BorderSide(width: borderWidth, color: borderColor),
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.blue.shade400,
    //               spreadRadius: 10,
    //               blurRadius: 15
    //             )
    //           ]
    //         ),
    //       ),
    //     ),
    //   ),
    //   // redButtonLogic ? PurpleFilter.noPara() : const EmptyContainer(),
    //   // for (PurpleFilter l in list) l
    // ]);
  }
}
