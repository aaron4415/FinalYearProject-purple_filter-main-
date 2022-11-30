import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../main.dart';
import '../upper/overlay_purple.dart';
import '../upper/upper_part.dart';

int time = 0;
double distance = 0;
double userAccelerationX = 0;
double userAccelerationY = 0;
double userAccelerationZ = 0;
double instantMovementX = 0;

double x = 0;

class RedButton extends StatefulWidget {
  const RedButton({Key? key}) : super(key: key);

  @override
  State<RedButton> createState() => _RedButtonState();
}

class _RedButtonState extends State<RedButton> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Sensors sensor = Sensors();
  bool _hasBeenPressed = true;
  double count = 0;
  var img = const AssetImage("images/button_icon.jpg");
  @override
  Widget build(BuildContext context) {
    dynamic width = MediaQuery.of(context).size.width;
    dynamic height = MediaQuery.of(context).size.height;
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _hasBeenPressed ? Colors.blue : Colors.red,
          shape: const CircleBorder(),
          fixedSize: Size(width / 4.5, height / 6),
          side: BorderSide(color: Colors.white, width: 5),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                child: GestureDetector(onLongPressStart:
                    (LongPressStartDetails longPressStartDetails) {
              _streamSubscriptions.add(sensor.userAccelerometerEvents
                  .listen((UserAccelerometerEvent event) {
                userAccelerationX = event.x;
                userAccelerationY = event.y;
                userAccelerationZ = event.z;

                distance += 0.5 * event.x * count * count;
                if (distance > 1000) {
                  distance = 10;
                  count = 1;
                }
                if (distance < -1000) {
                  distance = -10;
                  count = 1;
                }
                print(list.length);

                setState(() {
                  distance;
                  instantMovementX;
                  if (userAccelerationX.abs() > 0.3) {
                    PurpleFilter.noPara().condition = 0;
                    list.add(PurpleFilter());
                  }

                  for (PurpleFilter l in list) {
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                      if (distance > 0) {
                        l.condition++;
                      } else {
                        l.condition--;
                      }
                      // if (l.condition < -300 || l.condition > 300) {
                      //   list.remove(l);
                      // }
                    });
                  }

                  Timer.periodic(const Duration(seconds: 1), (timer) {
                    time++;
                    count++;
                    if (time >= 5) {
                      time = 5;
                      timer.cancel();
                    }
                    mainTime = time;
                  });
                  redButtonLogic = true;
                });
              }));
              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              });
            }, onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
              time = 0;
              mainTime = time;
              redButtonLogic = false;
              count = 0;
              distance = 0;
              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              });
              setState(() {
                for (StreamSubscription s in _streamSubscriptions) {
                  s.cancel();
                }
                list = [];
              });
            })),
          ],
        ));
  }
}
