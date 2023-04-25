import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bordered_text/bordered_text.dart';

late List<CameraDescription> cameras;
late CameraController cameraController;

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({Key? key}) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late Future<void> initializeCameraControllerFuture;
  late Future<void> lockCaptureOrientationFuture;

  void initializeCameraController() {
    final camera = cameras.first;
    cameraController = CameraController(camera, ResolutionPreset.low,
        imageFormatGroup: ImageFormatGroup.yuv420);
    initializeCameraControllerFuture = cameraController.initialize();
    lockCaptureOrientationFuture =
        cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
    cameraController.lockCaptureOrientation();
  }

  @override
  void initState() {
    super.initState();
    initializeCameraController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<void>(
            future: initializeCameraControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: const Color(0x44000000),
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Center(
                          child: BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.blue,
                              child: const Text('Fanta-Health',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)))),
                    ),
                    body: FutureBuilder<void>(
                        future: lockCaptureOrientationFuture,
                        builder: (context, snapshot) {
                          return ClipRect(
                              clipBehavior: Clip.hardEdge,
                              child: OverflowBox(
                                  maxHeight: MediaQuery.of(context).size.height,
                                  alignment: Alignment.topCenter,
                                  child: CameraPreview(cameraController)));
                        }));
              } else {
                return const Center(
                    child: CircularProgressIndicator()); //loading
              }
            }));
  }
}
