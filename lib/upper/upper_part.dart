import 'package:flutter/material.dart';
import 'package:purple_filter/main.dart';

import 'camera_preview.dart';
import 'empty_container.dart';
import 'overlay_purple.dart';

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
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  // Animation
  late final Animation<double> _animation =
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
