import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../detect_distance/allocator.dart';
import '../../main.dart';
import '../homePage.dart';
import '../upper/camera_preview.dart';

import 'package:purple_filter/home/lower/lower_part_second.dart';
import 'package:purple_filter/home/lower/lower_part_first.dart';
import 'package:purple_filter/home/upper/upper_part.dart' as globals;

import '../upper/upper_part.dart';

int time = 0;
int distance = 0;
late Timer timer;
bool timerFinished = true;
bool hasBeenPressed = false;

bool isPlayingAnimation = false;
double x = 0;

late CameraImage _savedImage;
ffi.Allocator allocator = A();

final player = AudioPlayer();

int imgData = 0;

class DisinfectionButton extends StatefulWidget {
  const DisinfectionButton({Key? key}) : super(key: key);

  @override
  State<DisinfectionButton> createState() => _DisinfectionButtonState();
}

class _DisinfectionButtonState extends State<DisinfectionButton> {
  late StreamSubscription<UserAccelerometerEvent> subscription;
  double count = 0;

  List<double> filteredVelocity = [];

  double accelerationMinMax = 0;
  double accelerationMin = 0;
  double accelerationMax = 0;

  bool isRealSpeedChange = false;


  var img = const AssetImage("images/button_icon.jpg");

  Sensors sensor = Sensors();

  @override
  void dispose() {
    globals.controller.dispose();
    super.dispose();
  }
  //
  @override
  void initState() {
    super.initState();

    player.setSource(AssetSource('succ.mp3'));
    player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> determineEffectiveDisinfection() async{
    if (actualDistance != 0 && actualDistance != -1) {
      int d90Dose = (67 * 4  * math.pi * math.pow(actualDistance / 100, 2) / 1.3). ceil();
      setState(() {
        if (timerFinished == true) {
          timerFinished = false;
          print("This Timer Triggered By d90Dose of $d90Dose");
          timer = Timer.periodic(
              Duration(milliseconds: d90Dose * 10), (timer) {
                setState(() {
                  if (disinfectionPercentage < 100) { disinfectionPercentage += 1; borderColor = blueColor;}
                  else { player.resume(); timer.cancel(); timerFinished = true; borderColor = redColor;}
                });
          });
        }
      });
    }
  }

  /// This function has a similar replacement implementd in lower_part_first initstate
  // Future<void> determineReset() async {
  //   setState(() {
  //     if (isDeviceMoving) {
  //       disinfectionPercentage = 0;
  //       if (timer.isActive) timer.cancel();
  //       player.release();
  //       determineEffectiveDisinfection().ignore();
  //     }
  //   });
  // }

  void _processCameraImage(CameraImage image) async {
    setState(() {
      _savedImage = image;
    });
  }

  void actualDistanceCalculation(int pixelDifferencePercentage) {
    if (pixelDifferencePercentage >= 90) {
      actualDistance = 0.5;
    } else if (pixelDifferencePercentage < 90 &&
        pixelDifferencePercentage >= 87) {
      actualDistance = 0.6;
    } else if (pixelDifferencePercentage < 87 &&
        pixelDifferencePercentage >= 75) {
      actualDistance = 0.7;
    } else if (pixelDifferencePercentage < 75 &&
        pixelDifferencePercentage >= 68) {
      actualDistance = 0.8;
    } else if (pixelDifferencePercentage < 68 &&
        pixelDifferencePercentage >= 63) {
      actualDistance = 0.9;
    } else if (pixelDifferencePercentage < 63 &&
        pixelDifferencePercentage >= 57) {
      actualDistance = 1.0;
    } else if (pixelDifferencePercentage < 57 &&
        pixelDifferencePercentage >= 53) {
      actualDistance = 1.1;
    } else if (pixelDifferencePercentage < 53 &&
        pixelDifferencePercentage >= 47) {
      actualDistance = 1.2;
    } else if (pixelDifferencePercentage < 47 &&
        pixelDifferencePercentage >= 43) {
      actualDistance = 1.3;
    } else if (pixelDifferencePercentage < 43 &&
        pixelDifferencePercentage >= 40) {
      actualDistance = 1.4;
    } else if (pixelDifferencePercentage < 40 &&
        pixelDifferencePercentage >= 38) {
      actualDistance = 1.5;
    } else if (pixelDifferencePercentage < 38 &&
        pixelDifferencePercentage >= 36) {
      actualDistance = 1.6;
    } else if (pixelDifferencePercentage < 36 &&
        pixelDifferencePercentage >= 33) {
      actualDistance = 1.7;
    } else if (pixelDifferencePercentage < 33 &&
        pixelDifferencePercentage >= 31) {
      actualDistance = 1.8;
    } else if (pixelDifferencePercentage < 31 &&
        pixelDifferencePercentage >= 30) {
      actualDistance = 1.9;
    } else if (pixelDifferencePercentage < 30 &&
        pixelDifferencePercentage >= 29) {
      actualDistance = 2.0;
    } else if (pixelDifferencePercentage < 29 &&
        pixelDifferencePercentage >= 27) {
      actualDistance = 2.2;
    } else if (pixelDifferencePercentage < 27 &&
        pixelDifferencePercentage >= 26) {
      actualDistance = 2.4;
    } else if (pixelDifferencePercentage < 26 &&
        pixelDifferencePercentage >= 25) {
      actualDistance = 2.5;
    } else if (pixelDifferencePercentage < 25 &&
        pixelDifferencePercentage >= 24) {
      actualDistance = 2.6;
    } else if (pixelDifferencePercentage < 24 &&
        pixelDifferencePercentage >= 23) {
      actualDistance = 2.7;
    }else if (pixelDifferencePercentage < 23 &&
        pixelDifferencePercentage >= 22) {
      actualDistance = 2.9;
    } else if (pixelDifferencePercentage < 22 &&
        pixelDifferencePercentage >= 20) {
      actualDistance = 3.0;
    } else if (pixelDifferencePercentage < 20 &&
        pixelDifferencePercentage >= 19) {
      actualDistance = 3.2;
    } else if (pixelDifferencePercentage < 19 &&
        pixelDifferencePercentage >= 18) {
      actualDistance = 3.4;
    } else if (pixelDifferencePercentage < 18 &&
        pixelDifferencePercentage >= 17) {
      actualDistance = 3.5;
    } else if (pixelDifferencePercentage < 17 &&
        pixelDifferencePercentage >= 16) {
      actualDistance = 3.6;
    } else if (pixelDifferencePercentage < 16 &&
        pixelDifferencePercentage >= 15) {
      actualDistance = 3.7;
    } else if (pixelDifferencePercentage < 15 &&
        pixelDifferencePercentage >= 14) {
      actualDistance = 3.9;
    } else if (pixelDifferencePercentage < 14 &&
        pixelDifferencePercentage >= 13) {
      actualDistance = 4.0;
    } else if (pixelDifferencePercentage < 13 &&
        pixelDifferencePercentage >= 12) {
      actualDistance = 4.4;
    } else if (pixelDifferencePercentage < 12 &&
        pixelDifferencePercentage >= 11) {
      actualDistance = 4.8;
    } else if (pixelDifferencePercentage < 11 &&
        pixelDifferencePercentage >= 10) {
      actualDistance = 5.0;
    } else if (pixelDifferencePercentage < 10) {
      actualDistance = 5.0;
    } else {
      actualDistance = 0;
    }
  }

  Future<void> calculateDifference(savedImage) async {
    ffi.Pointer<ffi.Uint8> p = allocator.allocate(savedImage.planes[0].bytes.length);
    ffi.Pointer<ffi.Uint8> p1 = allocator.allocate(savedImage.planes[1].bytes.lengthInBytes);

    Uint8List pointerList = p.asTypedList(savedImage.planes[0].bytes.length);
    Uint8List pointerList1 = p1.asTypedList(savedImage.planes[1].bytes.length);

    pointerList.setRange(0, savedImage.planes[0].bytes.length, savedImage.planes[0].bytes);

    pointerList1.setRange(0, savedImage.planes[1].bytes.lengthInBytes,
        savedImage.planes[1].bytes);

    ffi.Pointer<ffi.Int> imgP = conv(
        p,
        p1,
        savedImage.planes[0].bytes.length,
        savedImage.planes[1].bytes.length,
        savedImage.planes[0].bytesPerRow,
        1,
        savedImage.width,
        savedImage.height
    );
    imgData = imgP.value;

    allocator.free(p);
    allocator.free(p1);
    setState(() {
      pixelDifferencePercentage = imgData == -1 ? pixelDifferencePercentage : imgData;
      actualDistanceCalculation(pixelDifferencePercentage); // This void() changes the value of $actualDistance
      progressBarPercentage = 1 - (pixelDifferencePercentage / 100);
      print("$progressBarPercentage");
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic width = MediaQuery.of(context).size.width;
    dynamic height = MediaQuery.of(context).size.height;

    GestureDetector disinfectionButtonListener = GestureDetector(
        onLongPressStart: (LongPressStartDetails longPressStartDetails) async {
          print("Long Press Started");
          await cameraController.startImageStream((CameraImage image) async {
            _processCameraImage(image);
            calculateDifference(_savedImage);
          });

          subscription = sensor.userAccelerometerEvents.listen((UserAccelerometerEvent event) async {
            setState(() {
              determineEffectiveDisinfection();
              actualDistance;
            });
          });

          setState(() { hasBeenPressed = true; redButtonLogic = true; });
        },
        onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
          print("Long Presss Ended");
          redButtonLogic = false;
          count = 0;
          distance = 0;

          setState(() {
            borderColor = blueColor;
            cameraController.stopImageStream().then((_) => print("Image Stream Stoppped"));
            hasBeenPressed = false;
            player.release().then((_) => print("Player Is Released"));
            timerFinished = true;
            imgData = 0;
            pixelDifferencePercentage = 0;
            actualDistance = 0;
            progressBarPercentage = 0;
            disinfectionPercentage = 0;
            subscription.cancel().then((_) => print("Sensor Subscription Is Canceled"));
            timer.cancel();
          });
        });

    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shadowColor: hasBeenPressed ? Colors.red.shade200 : Colors.lightBlue.shade300,
          // backgroundColor: hasBeenPressed ? Colors.red : Colors.blue,
          backgroundColor: hasBeenPressed ? Colors.red.shade300 : Colors.lightBlue.shade400,
          shape: const CircleBorder(),
          fixedSize: Size(width / 5.5, height / 6.5),
          side: const BorderSide(color: Color.fromARGB(130, 234, 237, 236), width: 3),
        ),
        child: disinfectionButtonListener
    );
  }
}
