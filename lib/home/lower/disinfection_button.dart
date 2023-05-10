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

int time = 0;
int distance = 0;
late Timer timer;
bool timerFinished = true;

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
  bool _hasBeenPressed = true;
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
    if (actualDistance != 0) {
      int d90Dose = (67 * 4  * math.pi * math.pow(actualDistance / 100, 2) / 0.325). ceil();
      setState(() {
        if (timerFinished == true) {
          timerFinished = false;
          print("This Timer Triggered By d90Dose of $d90Dose");
          timer = Timer.periodic(
              Duration(milliseconds: d90Dose * 10), (timer) {
                setState(() {
                  if (disinfectionPercentage < 100) { disinfectionPercentage += 1; }
                  else { player.resume(); timer.cancel(); timerFinished = true;}
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
    if (pixelDifferencePercentage <= 80 &&
        pixelDifferencePercentage >= 70) {
      double firstDigit = pixelDifferencePercentage - 70;
      double secondDigit = 0.5;
      actualDistance = secondDigit + firstDigit / 10;
    } else if (pixelDifferencePercentage < 70 &&
        pixelDifferencePercentage >= 55) {
      double firstDigit = pixelDifferencePercentage - 55;
      double secondDigit = 1.5;
      actualDistance = secondDigit + firstDigit / 10;
    } else if (pixelDifferencePercentage < 55 &&
        pixelDifferencePercentage >= 45) {
      double firstDigit = pixelDifferencePercentage - 45;
      double secondDigit = 3;
      actualDistance = secondDigit + firstDigit / 10;
    } else if (pixelDifferencePercentage < 45 &&
        pixelDifferencePercentage >= 35) {
      double firstDigit = pixelDifferencePercentage - 35;
      double secondDigit = 4;
      actualDistance = secondDigit + firstDigit / 10;
    } else if (pixelDifferencePercentage < 35 &&
        pixelDifferencePercentage >= 25) {
      double firstDigit = pixelDifferencePercentage - 25;
      double secondDigit = 5;
      actualDistance = secondDigit + firstDigit / 10;
    } else if (pixelDifferencePercentage < 25 &&
        pixelDifferencePercentage >= 10) {
      double firstDigit = pixelDifferencePercentage - 10;
      double secondDigit = 6;
      actualDistance = secondDigit + firstDigit / 10;
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

          setState(() { _hasBeenPressed = !_hasBeenPressed; redButtonLogic = true; });
        },
        onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
          print("Long Presss Ended");
          redButtonLogic = false;
          count = 0;
          distance = 0;

          setState(() {
            cameraController.stopImageStream().then((_) => print("Image Stream Stoppped"));
            _hasBeenPressed = !_hasBeenPressed;
            player.release().then((_) => print("Player Is Released"));
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
          backgroundColor: _hasBeenPressed ? Colors.blue : Colors.red,
          shape: const CircleBorder(),
          fixedSize: Size(width / 5.5, height / 6.5),
          side: const BorderSide(color: Colors.white, width: 5),
        ),
        child: disinfectionButtonListener
    );
  }
}
