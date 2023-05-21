import 'package:flutter/material.dart';
import 'package:purple_filter/home/lower/lower_part.dart';
import 'package:purple_filter/home/lower/lower_part_first.dart';

import 'camera_preview.dart';

late AnimationController controller;

Color borderColor = Color.fromARGB(200, 50, 50, 237);
Color blueColor = Color.fromARGB(200, 50, 50, 237);
Color redColor = Color.fromARGB(255, 0, 255, 0);

class UpperPart extends StatefulWidget {
  const UpperPart({Key? key}) : super(key: key);

  @override
  State<UpperPart> createState() => _UpperPartState();
}

class _UpperPartState extends State<UpperPart> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.white,
                    spreadRadius: 3,
                    blurRadius: 4,
                    blurStyle: BlurStyle.normal,
                  ),
                  // BoxShadow(
                  //   color: borderColor,
                  //   spreadRadius: 5,
                  //   blurRadius: 3,
                  //   blurStyle: BlurStyle.normal,
                  // ),
                  BoxShadow(
                      color: borderColor,
                      spreadRadius: 4.5,
                      blurRadius: 6.5,
                      blurStyle: BlurStyle.outer
                  )
                ]
            ),
            child: const CameraPreviewWidget()
        ),
        Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular((10.0)))
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 5.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        if (disinfectionPercentage >= 100) Align(
            alignment: Alignment.center,
            child: Container(
              //margin: EdgeInsets.all(width / 4),
              width: width/4,
              height: width/4,
              decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 3.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
            )
        ),
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
              painter: Cross()
          )
        )
      ],
    );

  }
}

class Cross extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size){

    Paint paint = Paint();
    paint.color = borderColor;
    paint.strokeWidth = 2.0;
    canvas.drawLine(Offset(8, 0), Offset(-8, 0), paint);
    canvas.drawLine(Offset(0, 8), Offset(0, -8), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    Color currentColor = borderColor;
    if (currentColor != borderColor ) {
      return true;
    } else {
      return false;
    }
  }
}