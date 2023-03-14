import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'selectLanguagePage.dart';
import 'selectUIPage.dart';
import 'l10n/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

String nameFromDB = "";
String uid = "";
final TextEditingController _controllerUsername = TextEditingController();
Future<void> getNameFromDB() async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      uid = user.uid;
      final tempUrl =
          "https://us-central1-airy-phalanx-323908.cloudfunctions.net/app/api/username/$uid";
      final response = await http.get(Uri.parse(tempUrl));

      final tempData = jsonDecode(response.body);
      nameFromDB = tempData['data']["username"];
    }
  });
}

class SettingPageState extends State<SettingPage> {
  List<String> allItem = [];
  @override
  void initState() {
    super.initState();
    getNameFromDB();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 1, 36),
      body: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        child: Column(
          children: <Widget>[
            BorderedText(
              strokeWidth: 4.0,
              strokeColor: Colors.blue,
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
              size: width / 3,
              color: Colors.white,
            ),
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(top: height / 45),
              child: BorderedText(
                strokeWidth: 4.0,
                strokeColor: Colors.blue,
                child: Text(
                  nameFromDB,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height / 50,
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
                padding: EdgeInsets.only(top: height / 75),
                child: InkWell(
                  onTap: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.custom,
                      showCancelBtn: true,
                      confirmBtnText: 'Save',
                      cancelBtnText: "discard",
                      widget: TextFormField(
                        controller: _controllerUsername,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your New Username',
                          prefixIcon: Icon(
                            Icons.face,
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      onConfirmBtnTap: () async {
                        String tempUrl =
                            "https://us-central1-airy-phalanx-323908.cloudfunctions.net/app/api/updateUsername/$uid";
                        final response =
                            await http.put(Uri.parse(tempUrl), body: {
                          'username': _controllerUsername.text,
                        });
                        if (response.statusCode == 200) {
                          setState(() {
                            nameFromDB = _controllerUsername.text;
                          });
                        }
                      },
                    );
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Color.fromARGB(255, 3, 1, 36),
                      child: Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: width / 75, color: Colors.blue),
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(Icons.perm_identity, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: width / 120),
                              child: BorderedText(
                                strokeWidth: 4.0,
                                strokeColor: Colors.blue,
                                child: Text(
                                  LocaleKeys.changeName.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 30,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ),
                      ])),
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
                padding: EdgeInsets.only(top: height / 75),
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
                      color: Color.fromARGB(255, 3, 1, 36),
                      child: Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: width / 75, color: Colors.blue),
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(Icons.app_shortcut, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: width / 120),
                              child: BorderedText(
                                strokeWidth: 4.0,
                                strokeColor: Colors.blue,
                                child: Text(
                                  LocaleKeys.changeInterface.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 30,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ),
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
                      color: Color.fromARGB(255, 3, 1, 36),
                      child: Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: width / 75, color: Colors.blue),
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.settings_applications,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: width / 120),
                              child: BorderedText(
                                strokeWidth: 4.0,
                                strokeColor: Colors.blue,
                                child: Text(
                                  LocaleKeys.changeMode.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 30,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ),
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
                      color: Color.fromARGB(255, 3, 1, 36),
                      child: Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: width / 75, color: Colors.blue),
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.language, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: width / 120),
                            child: BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.blue,
                              child: Text(
                                LocaleKeys.changeLanguage.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 30,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ),
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
                      color: Color.fromARGB(255, 3, 1, 36),
                      child: Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: width / 75, color: Colors.blue),
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.table_view, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: width / 120),
                            child: BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.blue,
                              child: Text(
                                LocaleKeys.changeTableList.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 30,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                        ),
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
