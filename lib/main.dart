import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'contactUsPage.dart';
import 'home/upper/camera_preview.dart';
import 'home/homePage.dart';
import 'Login/login_screen.dart';
import 'package:cool_alert/cool_alert.dart';

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
    await Firebase.initializeApp(
      name: 'purple_filter',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on CameraException catch (e) {
    debugPrint('Error in fetching the camera: $e');
  } on FirebaseException catch (e) {
    debugPrint('Error in initializing firebase: $e');
  }

  cameras = await availableCameras();
  await EasyLocalization.ensureInitialized();
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
  MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool _keyStore = false;
  bool _firstTimeToUse = true;
  bool _logined = false;
  String _UID = "";

  @override
  void initState() {
    super.initState();
    _loadFirstTimeToUse();
    _loadsaveKeyStore();
    _loadIsLogin();
    _loadUserId();
  }

  @override
  void dispose() {
    super.dispose();
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

  _loadIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _logined = prefs.getBool("logined") ?? false;
    });
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _UID = prefs.getString("UID") ?? "noUser";
    });
  }

  _saveLogin() async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setBool('logined', false);
  }

  _saveUserId() async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setString('UID', "noUser");
  }

  List<Widget> returnPage() {
    if (_keyStore == false) {
      return <Widget>[
        QRViewPage(),
        SettingPage(),
        AboutUsPage(),
        const Text(
          '',
          style: optionStyle,
        ),
      ];
    } else {
      return <Widget>[
        HomePage(),
        SettingPage(),
        AboutUsPage(),
        const Text(
          '',
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
    switch (_selectedIndex) {
      case 0:
        break;

      case 3:
        CoolAlert.show(
          context: context,
          title: "Do you want to logout?",
          type: CoolAlertType.confirm,
          showCancelBtn: true,
          confirmBtnText: 'Yes',
          onConfirmBtnTap: () async {
            _saveLogin();
            _saveUserId();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          cancelBtnText: 'No',
          onCancelBtnTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          confirmBtnColor: Colors.green,
          barrierDismissible: false,
        );
        break;
    }
  }

  Widget displayFirstTimePage() {
    if (_firstTimeToUse == true) {
      return (Center(
        child: selectLanguagePage(),
      ));
    } else if (_logined == false) {
      return (Center(
        child: LoginScreen(),
      ));
    } else {
      return (Center(
        child: returnPage().elementAt(_selectedIndex),
      ));
    }
  }

/*   Widget displayContactPage() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('CityU'),
              subtitle: Text('83 Tat Chee Ave, Kowloon Tong'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('(852) 15145211'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('info@cityu.com'),
            ),
          ],
        ));
  } */

  Widget? displayBottomNavigationBar() {
    if (_firstTimeToUse == true || _keyStore == false || _logined == false) {
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
        resizeToAvoidBottomInset: false,
        body: displayFirstTimePage(),
        bottomNavigationBar: displayBottomNavigationBar());
  }
}
