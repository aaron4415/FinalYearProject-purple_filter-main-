import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'upper/upper_part.dart';
import 'lower/lower_part.dart';
import 'upper/camera_preview.dart';

int mainTime = 0;
bool redButtonLogic = false;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the camera: $e');
  }

  cameras = await availableCameras();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MaterialApp(home: HomePage()));
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      updateMainTime();
    });
  }

  Future updateMainTime() async {
    setState(() {
      mainTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 3, 1, 36),
        body: Column(
          children: [
            SizedBox(height: height / 2, child: UpperPart(time: mainTime)),
            LowerPart()
          ],
        ));
  }
}
