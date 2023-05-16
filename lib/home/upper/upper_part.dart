import 'package:flutter/material.dart';

import 'camera_preview.dart';
import 'purple_filter.dart';

List<PurpleFilter> list = [];
late AnimationController controller;
Color borderColor = Color.fromARGB(200, 50, 50, 237);
Color blueColor = Color.fromARGB(200, 50, 50, 237);
Color redColor = Color.fromARGB(255, 237, 50, 50);

class UpperPart extends StatefulWidget {
  const UpperPart({Key? key}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: borderColor,
                    spreadRadius: 10,
                    blurRadius: 15,
                    blurStyle: BlurStyle.solid
                )
              ]
          ),
        ),
        const CameraPreviewWidget()
      ]
    );

  }
}
