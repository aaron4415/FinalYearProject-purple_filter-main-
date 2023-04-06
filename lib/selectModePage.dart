import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting.dart';

class SelectModePage extends StatefulWidget {
  const SelectModePage({Key? key}) : super(key: key);
  @override
  State<SelectModePage> createState() => SelectModePageState();
}

class SelectModePageState extends State<SelectModePage> {
  // This widget is the home page of your application.
  String mode = "normal";
  List<String> allItem = [];
  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  _loadMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mode = prefs.getString("mode") ?? "normal";
    });
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
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
                            padding: EdgeInsets.only(
                                left: width / 45, top: height / 100),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.chevron_left,
                              ),
                            ),
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: height / 50),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "請選擇模式",
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
                            "請選擇用於App中的模式，不同的模式有不同的功能",
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
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "快速模式",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "普通模式",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {}, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: Colors.white,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "...模式",
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
