import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:purple_filter/home/lower/lower_part_second.dart';

import 'package:sensors_plus/sensors_plus.dart';

import '../../detect_distance/allocator.dart';
import '../../detect_distance/type_definition.dart';
import '../../main.dart';
import '../homePage.dart';
import '../upper/purple_filter.dart';
import '../upper/upper_part.dart';
import '../upper/camera_preview.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:purple_filter/home/upper/upper_part.dart' as globals;

int time = 0;
double distance = 0;
double userAccelerationX = 0;
double userAccelerationY = 0;
double userAccelerationZ = 0;
double instantMovementX = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    dynamic width = MediaQuery.of(context).size.width;
    dynamic height = MediaQuery.of(context).size.height;

    player.setSource(AssetSource('succ.mp3'));

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
        pixelDifference = imgData;
        print("$pixelDifference");
      });
    }

    GestureDetector disinfectionButtonListener = GestureDetector(
        onLongPressStart: (LongPressStartDetails longPressStartDetails) async {
      await cameraController.startImageStream((CameraImage image) async {
        _processCameraImage(image);
        calculateDifference(_savedImage);
      });

      setState(() {
        imgData;
        print("$imgData");
      });

      globals.borderColor = Colors.blue;
      timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
        time++;
        if (time >= 5) {
          time = 5;
          timer.cancel();
          player.resume(); //play the sound effect
          setState(() {
            globals.borderColor = Colors.red;
          });
        }
        mainTime = time;
      });
      redButtonLogic = true;

      // _streamSubscriptions.add(sensor.userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      //     //userAccelerationX = event.x; userAccelerationY = event.y; userAccelerationZ = event.z;
      //     globals.visible = true;
      //     // distance += 0.5 * event.x * count * count;
      //     // if (distance > 1000) { distance = 10; count = 1; }
      //     // if (distance < -1000) { distance = -10; count = 1; }
      //
      //     setState(() {
      //       // distance; instantMovementX;
      //       // if (userAccelerationX.abs() > 0.3) {
      //       //   PurpleFilter.noPara().condition = 0;
      //       //   list.add(PurpleFilter());
      //       // }
      //
      //       // for (PurpleFilter l in list) {
      //       //   timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      //       //     if (distance > 0) { l.condition++; } else { l.condition--; }
      //       //   });
      //       // }
      //     });
      // }));
      setState(() {
        _hasBeenPressed = !_hasBeenPressed;
      });
    }, onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
      mainTime = 0;
      redButtonLogic = false;
      count = 0;
      distance = 0;
      setState(() {
        globals.borderColor = Colors.blue;
        _hasBeenPressed = !_hasBeenPressed;
        // for (StreamSubscription s in _streamSubscriptions) { s.cancel(); }
        list.clear();
        cameraController.stopImageStream();
        player.release();
        // timer1.cancel();
        timer2.cancel();
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
        child: disinfectionButtonListener);
  }
}
