import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;

import 'scanner_widget.dart';
import 'main.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  QRViewController? controller;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);
    super.initState();

    controller?.resumeCamera();
    initPlatformState();
  }

  _saveMode(String modeFromDB) async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setString('mode', modeFromDB);
  }

  _saveKeyStore() async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setBool('keyStore', true);
  }

  Future<Timer> simulateInitialDataLoading() async {
    return Timer(
      const Duration(seconds: 2),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyStatefulWidget(),
        ),
      ),
    );
  }

  Barcode? result;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController _unameController = TextEditingController();
  var used = true;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  String? _deviceId;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  static const IconData qr_code_scanner_rounded =
      IconData(0xf00cc, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore db = FirebaseFirestore.instance;
    // final docRef = db.collection("qrcodeKeys").doc("F7xBndPDCQMbogv0F4m1");
    // void checkQrcode() async {
    //   // Call the user's CollectionReference to add a new user

    //   final DocumentSnapshot key = await FirebaseFirestore.instance
    //       .collection("qrcodeKeys")
    //       .doc("F7xBndPDCQMbogv0F4m1")
    //       .get();
    //   log("hihih");
    // }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
          toolbarHeight: height / 16,
          leading: const Icon(qr_code_scanner_rounded, color: Colors.black),
          title: const Text(
            'Scan QR code',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: height / 45,
                  ),
                  const Center(
                    child: Text(
                      'Please use the Qrcode to activate your product',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ],
          )),
          Expanded(
              flex: 10,
              child: Stack(children: [
                _buildQrView(context),
                ScannerAnimation(
                  false,
                  width,
                  animation: _animationController,
                ),
              ])),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        controller.pauseCamera();
        bool showProgress = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: ((BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            })
        );
        try {
          final networkResult = await InternetAddress.lookup('example.com');
          if (networkResult.isNotEmpty &&
              networkResult[0].rawAddress.isNotEmpty) {
            final keyId = "${result?.code}";
            var result1 = keyId.replaceAll("\n", "");

            final tempUrl =
                "https://us-central1-fantahealth-1f00b.cloudfunctions.net/app/api/qrcodeKeys/$result1";
            final putUrl =
                "https://us-central1-fantahealth-1f00b.cloudfunctions.net/app/api/updateQrCode/$result1";

            final response = await http.get(Uri.parse(tempUrl));

            if (response.statusCode == 200) {
              // If the server did return a 200 OK response,
              // then parse the JSON.
              final tempCheckState = jsonDecode(response.body);
              print("displaying the message");
              print(tempCheckState);
              if (tempCheckState['data'] == null) {
                print("response code = 200");
                return CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    text: "This key is not valid",
                    onConfirmBtnTap: (() {
                      controller.resumeCamera();
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      );
                    }));
              } else if (tempCheckState['data']["deviceId"] == _deviceId &&
                  tempCheckState['data']["used"] == "true") {
                _saveKeyStore();
                _saveMode(tempCheckState['data']["mode"]);
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text:
                        "This key is used on same device, Your application has been successfully activated!",
                    onConfirmBtnTap: () {
                      print("step 1");
                      controller.resumeCamera();
                      print("step 2");
                      Navigator.of(context, rootNavigator: true).pop();
                      print("sstep 3");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      );
                      print("step 4");
                      dispose();
                    });
              } else if (tempCheckState['data']["used"] == false) {
                //state change
                _saveKeyStore();
                _saveMode(tempCheckState['data']["mode"]);
                final putResponse = await http.put(Uri.parse(putUrl),
                    body: {'used': 'true', 'deviceId': _deviceId});
                print('Response status: ${putResponse.statusCode}');
                print('Response body: ${putResponse.body}');
                print('Now Disposing Data');
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Your application has been successfully activated!",
                    onConfirmBtnTap: () async {
                      print("step 1");
                      controller.resumeCamera();
                      print("step 2");
                      Navigator.of(context, rootNavigator: true).pop();
                      print("step 3");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      ).then((_) => print("step 4"));
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      print(sp.getBool('keyStore'));
                      dispose();
                    });
              }
              else {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    text:
                        "This key has been used, you need to use same device to activate",
                    onConfirmBtnTap: (() {
                      controller.resumeCamera();
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyStatefulWidget()),
                      );
                    }));
              }
            } else {
              // If the server did not return a 200 OK response,
              // then throw an exception.
              print("response code != 200");
              return CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  text: "This key is not valid",
                  onConfirmBtnTap: (() {
                    controller.resumeCamera();
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyStatefulWidget()),
                    );
                  }));
            }
          }
        } on SocketException catch (_) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "Please connect internet",
            onConfirmBtnTap: () async {
              controller.resumeCamera();
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyStatefulWidget()),
              );
            },
          );
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }
}
