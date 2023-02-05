import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'selectLanguagePage.dart';
import 'qrcodePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'purple_filter',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    /// 1. Wrap your App widget in the Phoenix widget

    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(
        storage: KeyStorage(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.storage});
  final KeyStorage storage;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String _keyStore = "false";
  bool _firstTimeToUse = true;
  @override
  void initState() {
    super.initState();
    _loadFirstTimeToUse();
    widget.storage.readConfig().then((value) {
      setState(() {
        _keyStore = value;
      });
    });
  }

  _loadFirstTimeToUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTimeToUse = prefs.getBool("firstTime") ?? true;
    });
  }

  List<Widget> returnPage() {
    if (_keyStore == "false") {
      return <Widget>[
        QRViewPage(storage: KeyStorage()),
        selectLanguagePage(storage: ConfigStorage()),
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
        const Text(
          'main program',
          style: optionStyle,
        ),
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
        child: selectLanguagePage(
          storage: ConfigStorage(),
        ),
      );
    } else {
      return Center(
        child: returnPage().elementAt(_selectedIndex),
      );
    }
  }

  Widget? displayBottomNavigationBar() {
    if (_firstTimeToUse == true) {
      return null;
    } else {
      return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_settings_alt, color: Colors.black),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support, color: Colors.black),
            label: 'Contact us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded, color: Colors.black),
            label: 'Sign out',
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
