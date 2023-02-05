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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class ContentOfBookmark {
  String content1;
  String content2;
  String content3;
  String content4;

  ContentOfBookmark(
      {required this.content1,
      required this.content2,
      required this.content3,
      required this.content4});
}

class MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text("Save"),
                style: ButtonStyle(
                  textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 16)), //字体
                ),
                onPressed: () {
                  _addBookmark();
                },
              ),
            ),
            Expanded(
              child: Text('Craft beautiful UIs', textAlign: TextAlign.center),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
