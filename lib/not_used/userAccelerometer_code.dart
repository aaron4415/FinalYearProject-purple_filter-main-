
double userAccelerationX = 0;
double userAccelerationY = 0;
double userAccelerationZ = 0;
double instantMovementX = 0;

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