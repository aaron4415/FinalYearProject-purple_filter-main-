import 'dart:ffi';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'selectLanguagePage.dart';
import 'qrViewPage.dart';
import 'firebase_options.dart';
import 'setting.dart';

import 'detect_distance/convert_image_platform_interface.dart';

import 'l10n/codegen_loader.g.dart';
import 'l10n/locale_keys.g.dart';

import 'home/upper/camera_preview.dart';
import 'home/homePage.dart';

class ConvertImage {
  Future<String?> getPlatformVersion() {
    return ConvertImagePlatform.instance.getPlatformVersion();
  }
}

final DynamicLibrary convertImageLib = Platform.isAndroid
    ? DynamicLibrary.open("libconvertImage.so")
    : DynamicLibrary.process();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the camera: $e');
  }

  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    name: 'purple_filter',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      /// 1. Wrap your App widget in the Phoenix widget
      EasyLocalization(
        supportedLocales: [
          Locale('en'), // English
          Locale('zh', 'Hans'), // simplified Chinese
          Locale('zh', 'Hant'), // traditional Chinese
          Locale('ja'), // Japanese
        ],
        path: 'lib/l10n',
        assetLoader: CodegenLoader(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      /*    localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        // const Locale('cn'), // simplified Chinese
        const Locale('zh'), // traditional Chinese
        const Locale('ja'), // Japanese
      ], */
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool _keyStore = false;
  bool _firstTimeToUse = true;
  @override
  void initState() {
    super.initState();
    _loadFirstTimeToUse();
    _loadsaveKeyStore();
  }

  _loadFirstTimeToUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTimeToUse = prefs.getBool("firstTime") ?? true;
    });
  }

  _loadsaveKeyStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _keyStore = prefs.getBool("keyStore") ?? false;
    });
  }

  List<Widget> returnPage() {
    if (_keyStore == false) {
      return <Widget>[
        QRViewPage(),
        SettingPage(),
        const Text(
          'you can cantact us by sending  email...',
          style: optionStyle,
        ),
        const Text(
          'Authentication',
          style: optionStyle,
        ),
      ];
    } else {
      return <Widget>[
        HomePage(),
        SettingPage(),
        const Text(
          'you can cantact us by sending  email...',
          style: optionStyle,
        ),
        const Text(
          'Authentication',
          style: optionStyle,
        ),
      ];
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // final List<Widget> _widgetOptions = <Widget>[
  //   returnPage,
  //   const Text(
  //     'Index 1: School',
  //     style: optionStyle,
  //   ),
  //   AuthAppPage(storage: ConfigStorage()),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget displayFirstTimePage() {
    if (_firstTimeToUse == true) {
      return Center(
        child: selectLanguagePage(),
      );
    } else {
      return Center(
        child: returnPage().elementAt(_selectedIndex),
      );
    }
  }

  Widget? displayBottomNavigationBar() {
    if (_firstTimeToUse == true || _keyStore == false) {
      return null;
    } else {
      return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_settings_alt, color: Colors.black),
            label: LocaleKeys.setting.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support, color: Colors.black),
            label: LocaleKeys.contactUs.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded, color: Colors.black),
            label: LocaleKeys.signOut.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: displayFirstTimePage(),
        bottomNavigationBar: displayBottomNavigationBar());
  }
}
