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

class _UpperPartState extends State<UpperPart> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5.0, style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
                color: borderColor,
                // spreadRadius: _animation.value,
                // blurRadius: _animation.value,
                spreadRadius: 10.0,
                blurRadius: 15.0,
                blurStyle: BlurStyle.normal
            ),
            BoxShadow(
                color: Colors.white,
                // spreadRadius: _animation.value * 0.7,
                // blurRadius: _animation.value * 0.7,
                spreadRadius: 6.0,
                blurRadius: 9.0,
                blurStyle: BlurStyle.outer
            ),
            const BoxShadow(
              color: Colors.black12,
              spreadRadius: 1.0,
              blurRadius: 1.0,
              blurStyle: BlurStyle.inner,
              offset: Offset(1.0, 2.0)
            )
          ]
        ),
        child: const CameraPreviewWidget()
    );

  }
}
