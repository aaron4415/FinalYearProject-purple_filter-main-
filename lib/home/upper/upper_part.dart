import 'package:flutter/material.dart';
import 'package:purple_filter/home/homePage.dart';

import 'camera_preview.dart';
import 'empty_container.dart';
import 'purple_filter.dart';

List<PurpleFilter> list = [];
late AnimationController controller;
Color borderColor = Colors.blue;

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
    double borderWidth = width / 40;

    return Stack(children: [
      const CameraPreviewWidget(),
      Align(
        alignment: Alignment.center,
        child: Center(
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: borderWidth, color: borderColor),
                bottom: BorderSide(width: borderWidth, color: borderColor),
                left: BorderSide(width: borderWidth, color: borderColor),
                right: BorderSide(width: borderWidth, color: borderColor),
              ),
            ),
          ),
        ),
      ),
      // redButtonLogic ? PurpleFilter.noPara() : const EmptyContainer(),
      // for (PurpleFilter l in list) l
    ]);
  }
}
