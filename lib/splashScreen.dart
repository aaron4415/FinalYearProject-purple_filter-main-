import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selectLanguagePage.dart';
import 'Login/login_screen.dart';

import 'mainUI.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);
  @override
  State<SplashScreenPage> createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  // This widget is the home page of your application.

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
    Future.delayed(Duration(seconds: 2), () {
      if (_firstTimeToUse == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const selectLanguagePage()),
        );
      } else if (_logined == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyUIWidget()),
        );
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
