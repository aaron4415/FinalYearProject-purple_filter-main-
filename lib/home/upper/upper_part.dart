import 'package:flutter/material.dart';
import 'package:purple_filter/home/homePage.dart';

import 'camera_preview.dart';
import 'empty_container.dart';
import 'purple_filter.dart';

List<PurpleFilter> list = [];
late AnimationController controller;
bool visible = false;

class UpperPart extends StatefulWidget {

  const UpperPart({Key? key}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart> with SingleTickerProviderStateMixin {
    @override
    void initState() {
      super.initState();
      controller = AnimationController(
            vsync: this,
            duration: const Duration(seconds: 1)
        )..repeat(reverse: true);
    }

    // Animation
    late final Animation<double> _animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    @override
    void dispose() {controller.dispose(); super.dispose();}

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
                          opacity: visible ? 1.0 : 0.0, // Widget visible/hidden ? 0.0 (invisible) : 1.0 (full visible)
                          duration: const Duration(seconds: 1),
                          child: FadeTransition(
                              opacity: _animation,
                              child: Container( height: height, width: width, color: Colors.white)
                        )
                    )
                )
            ),
            redButtonLogic ? PurpleFilter.noPara() : const EmptyContainer(),
            for (PurpleFilter l in list) l
        ]);
    }
}