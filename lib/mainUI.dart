import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'qrViewPage.dart';

import 'setting.dart';

import '../../Login/login_screen.dart';
import 'l10n/locale_keys.g.dart';
import 'contactUsPage.dart';

import 'home/homePage.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

class MyUIWidget extends StatefulWidget {
  MyUIWidget({Key? key}) : super(key: key);

  @override
  State<MyUIWidget> createState() => _MyUIWidgetState();
}

class _MyUIWidgetState extends State<MyUIWidget> {
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
          onConfirmBtnTap: () {
            _saveLogin();
            _saveUserId();
            FirebaseAuth.instance.signOut();
            GoogleSignIn().signOut();
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyStatefulWidget()),
            );
          },
          cancelBtnText: 'No',
          onCancelBtnTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyStatefulWidget()),
            );
          },
          confirmBtnColor: Colors.green,
          barrierDismissible: false,
        );
        break;
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
        body: returnPage().elementAt(_selectedIndex),
        bottomNavigationBar: displayBottomNavigationBar());
  }
}
