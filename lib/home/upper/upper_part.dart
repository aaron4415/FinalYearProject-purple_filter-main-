import 'package:flutter/material.dart';
import 'package:purple_filter/home/lower/disinfection_button.dart';
import 'package:purple_filter/home/lower/lower_part_first.dart';

import 'camera_preview.dart';

late AnimationController controller;

Color borderColor = Color.fromARGB(200, 50, 50, 237);
Color defaultColor = Color.fromARGB(200, 50, 50, 237);
Color blueColor = Color.fromARGB(200, 50, 50, 237);
Color redColor = Color.fromARGB(255, 157, 53, 10);
Color finishColor = Color.fromARGB(255,254,230,117);
Color redColor2 = Color.fromARGB(255, 222, 108, 47);
Color redColor3 = Color.fromARGB(255, 255, 208, 111);
Color redColor4 = Color.fromARGB(255, 198, 78, 18);


AssetImage backgroundImage = AssetImage("assets/images/blue-square.png");
AssetImage blueImage = AssetImage("assets/images/blue-square.png");
AssetImage redImage = AssetImage("assets/images/orange-square3.png");
AssetImage purpleImage = AssetImage("assets/images/purple-square.png");

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

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImage,
                  fit: BoxFit.fill
                )
            ),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 49) + EdgeInsets.only(top: 9) + EdgeInsets.only(bottom: 6) + EdgeInsets.all(2) + EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor,
                      spreadRadius: 2.0,
                      blurRadius: 3.0,
                      blurStyle: BlurStyle.outer
                    )
                  ]
                ),
                child: const CameraPreviewWidget()
              )
            )
          )
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 49) + EdgeInsets.only(top: 9) + EdgeInsets.only(bottom: 6) + EdgeInsets.all(8) + EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: disinfectionPercentage >= 100 ? Border.all(color: redColor3, width: 1.0) : Border.all(color: defaultColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular((5.0))),
            boxShadow: [
              if (disinfectionPercentage >= 100) BoxShadow(
                  color: Colors.white,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0,
                  blurRadius: 10.0
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 49) + EdgeInsets.only(top: 9) + EdgeInsets.only(bottom: 6) + EdgeInsets.all(23) + EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
              border: disinfectionPercentage >= 100 ? Border.all(color: redColor2, width: 1.0) : Border.all(color: defaultColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                if (disinfectionPercentage >= 100) BoxShadow(
                    color: redColor3,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    blurRadius: 10.0
                )
              ]
          ),
        ),
        if (disinfectionPercentage >= 100) Align(
            alignment: Alignment.center,
            child: Container(
              //margin: EdgeInsets.all(width / 4),
              width: width/4,
              height: width/4,
              decoration: BoxDecoration(
                  border: Border.all(color: redColor4, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      blurRadius: 10.0
                    )
                  ]
              ),
            )
        ),
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
              painter: Cross()
          )
        ),
        if (skinDetected) Center(
            child: Container(
                margin: EdgeInsets.only(top: height / 4),
                height: height / 2 * 0.2,
                width: width * 0.5,
                decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.red, width: 2.0), vertical: BorderSide(color: Colors.red, width: 1.0)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3.0,
                          spreadRadius: 1.0,
                          color: Colors.red,
                          blurStyle: BlurStyle.outer
                      )
                    ]
                ),
                child: Center(
                    child: Text(
                        "SKIN DETECTED",
                        style: TextStyle(
                            // foreground: Paint()
                            //   ..style = PaintingStyle.stroke
                            //   ..strokeWidth = 1
                            //   ..color = Colors.red,
                          color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        )
                    )
                )
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
    paint.strokeWidth = 1.5;
    canvas.drawLine(Offset(8, 0), Offset(-8, 0), paint);
    canvas.drawLine(Offset(0, 8), Offset(0, -8), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    Color currentColor = disinfectionPercentage >= 100 ? finishColor : defaultColor;
    if (currentColor != borderColor ) {
      return true;
    } else {
      return false;
    }
  }
}