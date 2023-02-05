import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Flutter Application',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: SettingPage(),
    );
  }
}

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
    _loadBookmark();
  }

  _loadBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      allItem = prefs.getStringList("contentOfBookmark") ?? [];
    });
  }

  _addBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      const data = {
        "content1": "123",
        "content2": "123",
        "content3": "123",
        "content4": "123"
      };
      var newItem = json.encode(data);
      allItem.add(newItem);

      prefs.setStringList('contentOfBookmark', allItem);
      print(allItem);
    });
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
                      child: new Text(
                        "個人資料",
                        style: TextStyle(
                            fontSize: height / 45, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    )),
              ),
            ),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: Text('個人資料', textAlign: TextAlign.left),
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
                      child: new Text(
                        "App設定",
                        style: TextStyle(
                            fontSize: height / 45, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    )),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: height / 45),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Text('更改介面'),
                )),
            Divider(color: Colors.black),
            Padding(
              padding: EdgeInsets.only(top: height / 45),
              child: Text('更改模式'),
            ),
            Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
