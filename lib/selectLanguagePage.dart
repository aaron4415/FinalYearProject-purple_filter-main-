import 'package:flutter/material.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'authMain.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthAppPage(storage: ConfigStorage()),
//     );
//   }
// }

class selectLanguagePage extends StatefulWidget {
  const selectLanguagePage({Key? key}) : super(key: key);

  @override
  State<selectLanguagePage> createState() => _selectLanguagePageState();
}

class _selectLanguagePageState extends State<selectLanguagePage> {
  String _language = "english";
  bool _firstTimeToUse = true;
  @override
  void initState() {
    super.initState();
    _loadFirstTimeToUse();
    _loadLanguagePage();
  }

  _loadFirstTimeToUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTimeToUse = prefs.getBool("firstTime") ?? true;
    });
  }

  _loadLanguagePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString("language") ?? "english";
    });
  }

  _saveFirstTimeToUse() async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setBool('firstTime', false);
  }

  _saveLanguage(String newLanguage) async {
    //實體化
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = newLanguage;
    });
    //獲取 counter 為 null 則預設值設定為 0
    //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

    //寫入
    await prefs.setString('language', newLanguage);
  }

  String showSelect() {
    switch (_language) {
      case "english":
        {
          return "Select Language";
          // statements;
        }

      case "simplifiedChinese":
        {
          return "选择语言";
          //statements;
        }

      case "traditionalChinese":
        {
          return "選擇語言";
          //statements;
        }

      case "japanese":
        {
          return "言語を選択する";
          //statements;
        }

      default:
        {
          return "Select Language";
          //statements;
        }
    }
  }

  Widget showReturnButton() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (_firstTimeToUse == false) {
      return Padding(
          padding: EdgeInsets.only(top: height / 300),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            }, // Handle your callback
            child: Ink(
                height: height / 20,
                width: width / 3,
                color: Colors.white,
                child: Padding(
                  //左边添加8像素补白
                  padding: EdgeInsets.only(left: width / 45, top: height / 100),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.chevron_left,
                    ),
                  ),
                )),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(top: height / 300),
          child: InkWell(
            onTap: () {}, // Handle your callback
            child: Ink(
              height: height / 20,
              width: width / 3,
              color: Colors.white,
            ),
          ));
    }
  }

  Future<void> changedMessage(String language) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your language has been changed to $language'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
                if (_firstTimeToUse == true) {
                  _saveFirstTimeToUse();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthAppPage()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                showReturnButton(),
                Padding(
                  padding: EdgeInsets.only(top: height / 50),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        showSelect(),
                        textAlign: TextAlign.center,
                      )),
                )
              ],
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
                          padding: EdgeInsets.only(
                              left: width / 45, top: height / 100),
                          child: new Text(
                            "請選擇用於App中的語言",
                            style: TextStyle(
                                fontSize: height / 55, color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ))),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: height / 250),
                child: InkWell(
                  onTap: () {
                    changedMessage("ENGLISH");
                    _saveLanguage("english");
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "ENGLISH",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    changedMessage("简体中文");
                    _saveLanguage("simplifiedChinese");
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "简体中文",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    changedMessage("繁體中文");
                    _saveLanguage("traditionalChinese");
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "繁體中文",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    changedMessage("日本語");
                    _saveLanguage("japanese");
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "日本語",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
