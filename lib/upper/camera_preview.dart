import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

late List<CameraDescription> cameras;

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({Key? key}) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late Future<void> initializeCameraControllerFuture;
  late Future<void> lockCaptureOrientationFuture;
  late CameraController cameraController;

  void initializeCameraController() {
    final camera = cameras.first;
    cameraController = CameraController(camera, ResolutionPreset.max);
    initializeCameraControllerFuture = cameraController.initialize();
    lockCaptureOrientationFuture = cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
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
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<void> (
          future: initializeCameraControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: FutureBuilder<void> (
                  future: lockCaptureOrientationFuture,
                  builder: (context, snapshot) {
                    return ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: OverflowBox(
                          maxHeight: MediaQuery.of(context).size.height,
                          alignment: Alignment.topCenter,
                          child: CameraPreview(cameraController)
                        )
                    );
                  }
                )
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      )
    );
  }
}
