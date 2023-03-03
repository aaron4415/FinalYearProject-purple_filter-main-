import 'package:flutter/material.dart';

import 'selectLanguagePage.dart';
import 'selectUIPage.dart';
import 'l10n/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bordered_text/bordered_text.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {

  List<String> allItem = [];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff0080FF),
      body: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        child: Column(
          children: <Widget>[
            BorderedText(
              strokeWidth: 4.0,
              strokeColor: Colors.black,
              child: Text(
                LocaleKeys.setting.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height / 40,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Color(0xffFFFFFF)),
            Icon(
              Icons.account_circle,
              size: width / 2,
              color: Colors.white,
            ),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: BorderedText(
                strokeWidth: 4.0,
                strokeColor: Colors.black,
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height / 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: Align(
                child: Container(
                    width: width,
                    height: height * 0.05,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Padding(
                          //左边添加8像素补白
                          padding: EdgeInsets.only(right: width / 1.3),
                          child: BorderedText(
                            strokeWidth: 4.0,
                            strokeColor: Colors.black,
                            child: Text(
                              LocaleKeys.nickName.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height / 45,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ))),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: height / 45),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Color(0xff0080FF),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Icon(Icons.perm_identity, color: Colors.white),
                              BorderedText(
                                strokeWidth: 4.0,
                                strokeColor: Colors.black,
                                child: Text(
                                  LocaleKeys.changeName.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 45,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            ]),
                          ])),
                  //Text('更改介面'),
                )),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: Align(
                child: Container(
                    width: width,
                    height: height * 0.05,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Padding(
                          //左边添加8像素补白
                          padding: EdgeInsets.only(right: width / 1.3),
                          child: BorderedText(
                            strokeWidth: 4.0,
                            strokeColor: Colors.black,
                            child: Text(
                              LocaleKeys.appSettings.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height / 45,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ))),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectUIPage()),
                    );
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Color(0xff0080FF),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.app_shortcut, color: Colors.white),
                            BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.black,
                              child: Text(
                                LocaleKeys.changeInterface.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 45,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ])),
                )),
            Divider(color: Colors.white),
            Padding(
                padding: EdgeInsets.only(top: height / 100),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Color(0xff0080FF),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.settings_applications,
                                color: Colors.white),
                            BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.black,
                              child: Text(
                                LocaleKeys.changeMode.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 45,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ])),
                  //Text('更改介面'),
                )),
            Divider(color: Colors.white),
            Padding(
                padding: EdgeInsets.only(top: height / 100),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => selectLanguagePage()),
                    );
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Color(0xff0080FF),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.language, color: Colors.white),
                            BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.black,
                              child: Text(
                                LocaleKeys.changeLanguage.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 45,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ])),
                  //Text('更改介面'),
                )),
            Divider(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
