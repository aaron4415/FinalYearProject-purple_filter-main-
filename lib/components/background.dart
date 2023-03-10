import 'package:flutter/material.dart';

// class Background extends StatelessWidget {
//   final Widget child;
//   const Background({
//     Key? key,
//     required this.child,
//     this.topImage = "assets/images/login_top_new.png",
//     this.bottomImage = "assets/images/login_bottom.png",
//   }) : super(key: key);
//
//   final String topImage, bottomImage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Positioned(
//               top: 0,
//               left: 0,
//               child: Image.asset(
//                 topImage,
//                 width: 120,
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: Image.asset(bottomImage, width: 120),
//             ),
//             SafeArea(child: child),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Background extends StatefulWidget {
  final Widget child;

  final String topImage;
  final String bottomImage;

  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/login_top_new.png",
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  @override
  State<Background> createState() => BackgroundState();
}

class BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                widget.topImage,
                width: 120,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(widget.bottomImage, width: 120),
            ),
            SafeArea(child: widget.child),
          ],
        ),
      ),
    );
  }
}

