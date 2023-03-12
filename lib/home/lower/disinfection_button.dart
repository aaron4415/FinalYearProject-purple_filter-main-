import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:simple_kalman/simple_kalman.dart';

import '../../detect_distance/allocator.dart';
import '../../detect_distance/type_definition.dart';
import '../../main.dart';
import '../homePage.dart';
import '../upper/upper_part.dart';
import '../upper/camera_preview.dart';

import 'package:purple_filter/home/lower/lower_part_second.dart';
import 'package:purple_filter/home/upper/upper_part.dart' as globals;

int time = 0;
int distance = 0;

bool isPlayingAnimation = false;
double x = 0;

late Convert conv;
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
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Sensors sensor = Sensors();
  bool _hasBeenPressed = true;
  double count = 0;

  List<double> filteredAcceleration = [];
  List<double> filteredGyroscope = [];

  List<double> filteredVelocity = [];

  double accelerationMinMax = 0;
  double accelerationMin = 0;
  double accelerationMax = 0;


  double nonZeroGyroscopeDataPercentage = 0;
  bool isDeviceMoving = false;
  bool isRealSpeedChange = false;

  void listenGyroscope() async {
    sensor.gyroscopeEvents.listen( (GyroscopeEvent event) {
      double combinedXYZ = event.z * event.z + event.y * event.y + event.x * event.x;
      final gyroscopeFilter = SimpleKalman(errorMeasure: 512, errorEstimate: 120, q: 0.5);
      double gyroscopeData = gyroscopeFilter.filtered(combinedXYZ);
      gyroscopeData = gyroscopeData < 0.0005 ? 0 : gyroscopeData;
      filteredGyroscope.add(gyroscopeData);
      if (filteredGyroscope.length > 300) filteredGyroscope.removeAt(0);

      List<double> sublistOfFilteredGyroscope =
      filteredGyroscope.length > 100 ?
      filteredGyroscope.sublist(filteredGyroscope.length-100,
          filteredGyroscope.length-1) : filteredGyroscope;
      int nonZeroCount = 0;
      for (double element in sublistOfFilteredGyroscope) {
        if (element != 0 ) nonZeroCount++;
      }
      nonZeroGyroscopeDataPercentage = nonZeroCount / 100; //threshold > 0.05 (5%)
      nonZeroCount = 0;
      setState(() {
        isDeviceMoving = nonZeroGyroscopeDataPercentage > 0.30 ? true : false;
      });
    });
  }

  var img = const AssetImage("images/button_icon.jpg");
  @override
  void dispose() {
    globals.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    conv = convertImageLib
        .lookup<ffi.NativeFunction<convert_func>>('convertImage')
        .asFunction<Convert>();
    player.setSource(AssetSource('succ.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    dynamic width = MediaQuery.of(context).size.width;
    dynamic height = MediaQuery.of(context).size.height;

    late Timer timer1;
    late Timer timer2;

    void _processCameraImage(CameraImage image) async {
      setState(() {
        _savedImage = image;
      });
    }

    Future<void> calculateDifference(_savedImage) async {
      ffi.Pointer<ffi.Uint8> p =
          allocator.allocate(_savedImage.planes[0].bytes.length);

      ffi.Pointer<ffi.Uint8> p1 =
          allocator.allocate(_savedImage.planes[1].bytes.lengthInBytes);

      Uint8List pointerList = p.asTypedList(_savedImage.planes[0].bytes.length);

      Uint8List pointerList1 =
          p1.asTypedList(_savedImage.planes[1].bytes.length);

      pointerList.setRange(
          0, _savedImage.planes[0].bytes.length, _savedImage.planes[0].bytes);
      pointerList1.setRange(0, _savedImage.planes[1].bytes.lengthInBytes,
          _savedImage.planes[1].bytes);

      ffi.Pointer<ffi.Int> imgP = conv(
          p,
          p1,
          _savedImage.planes[0].bytes.length,
          _savedImage.planes[1].bytes.length,
          _savedImage.planes[0].bytesPerRow,
          1,
          _savedImage.width,
          _savedImage.height);

      imgData = imgP.value;

      allocator.free(p);
      allocator.free(p1);
      setState(() {
        pixelDifferencePercentage = imgData == -1 ? pixelDifferencePercentage : imgData;
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
        print("pixelDifferencePercentage: $pixelDifferencePercentage");
        progressBarPercentage = 1 - (pixelDifferencePercentage / 100);
      });
    }

    GestureDetector disinfectionButtonListener = GestureDetector(
      onLongPressStart: (LongPressStartDetails longPressStartDetails) async {
        await cameraController.startImageStream((CameraImage image) async {
          _processCameraImage(image);
          calculateDifference(_savedImage);
        });

        _streamSubscriptions.add(listenGyroscope());
        timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
          time++;
          if (time >= 5) {
            time = 5;
            timer.cancel();
            player.resume(); //play the sound effect
          }
          mainTime = time;
        });
        redButtonLogic = true;
        setState(() { _hasBeenPressed = !_hasBeenPressed; });
    }, onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
      mainTime = 0;
      redButtonLogic = false;
      count = 0;
      distance = 0;
      setState(() {
        _hasBeenPressed = !_hasBeenPressed;
        list.clear();
        cameraController.stopImageStream();
        player.release();
        timer2.cancel();
        imgData = 0;
        pixelDifferencePercentage = 0;
        actualDistance = 0;
        progressBarPercentage = 0;
      });
    });

    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _hasBeenPressed ? Colors.blue : Colors.red,
          shape: const CircleBorder(),
          fixedSize: Size(width / 4.5, height / 6.5),
          side: const BorderSide(color: Colors.white, width: 5),
        ),
        child: disinfectionButtonListener
    );
  }
}
