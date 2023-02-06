import 'package:flutter/material.dart';

import 'selectLanguagePage.dart';
import 'selectUIPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  // This widget is the home page of your application.

  List<String> allItem = [];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        child: Column(
          children: <Widget>[
            Text("設定"),
            Divider(color: Colors.black),
            Icon(Icons.account_circle, size: width / 2),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: Text('Name', textAlign: TextAlign.center),
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Padding(
                          //左边添加8像素补白
                          padding: EdgeInsets.only(left: width / 45),
                          child: new Text(
                            "個人資料",
                            style: TextStyle(
                                fontSize: height / 45, color: Colors.black),
                            textAlign: TextAlign.left,
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
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Icon(
                                Icons.perm_identity,
                              ),
                              Text(
                                '個人資料',
                                textAlign: TextAlign.center,
                              ),
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Padding(
                          //左边添加8像素补白
                          padding: EdgeInsets.only(left: width / 45),
                          child: new Text(
                            "App設定",
                            style: TextStyle(
                                fontSize: height / 45, color: Colors.black),
                            textAlign: TextAlign.left,
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
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.app_shortcut,
                            ),
                            Text(
                              '更改介面',
                              textAlign: TextAlign.center,
                            ),
                          ])),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 100),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.settings_applications,
                            ),
                            Text(
                              '更改模式',
                              textAlign: TextAlign.center,
                            ),
                          ])),
                  //Text('更改介面'),
                )),
            Divider(color: Colors.black),
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
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.language,
                            ),
                            Text(
                              '更改語言',
                              textAlign: TextAlign.center,
                            ),
                          ])),
                  //Text('更改介面'),
                )),
            Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
