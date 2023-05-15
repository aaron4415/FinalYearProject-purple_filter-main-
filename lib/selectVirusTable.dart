import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import 'main.dart';

class SelectVirusTablePage extends StatefulWidget {
  const SelectVirusTablePage({Key? key}) : super(key: key);
  @override
  State<SelectVirusTablePage> createState() => SelectVirusTablePageState();
}

class SelectVirusTablePageState extends State<SelectVirusTablePage> {
  // This widget is the home page of your application.

  List<String> virusList = [];
  static const notChoosedColor = Colors.white;
  static const choosedColor = Colors.grey;
  Color _color0 = notChoosedColor;
  Color _color1 = notChoosedColor;
  Color _color2 = notChoosedColor;
  Color _color3 = notChoosedColor;
  Color _color4 = notChoosedColor;
  Color _color5 = notChoosedColor;
  Color _color6 = notChoosedColor;

  Widget? displayButton() {
    if (numberOfItem == 3) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          onPrimary: Colors.black, // Background color
        ),
        child: Text('Save'),
        onPressed: () {
          _saveVirusList();
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: 'You are updated the virus list successfully!',
            onConfirmBtnTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          );
        },
      );
    }
    return null;
  }

  int numberOfItem = 0;
  @override
  void initState() {
    super.initState();
    /* _loadVirusList(); */
  }

  _loadVirusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      virusList = prefs.getStringList("virusList") ??
          ["Ebola", "Coils", "Bacterial"];
    });
  }

  _saveVirusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      await prefs.setStringList('virusList', virusList);
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
                        "已選擇 " + numberOfItem.toString() + " 項目",
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
                            "請選擇3個想消毒的病毒",
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
                    if (_color0 == notChoosedColor) {
                      setState(() {
                        _color0 = choosedColor;
                        numberOfItem++;
                        virusList.add("Ebola");
                      });
                    } else {
                      setState(() {
                        _color0 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Ebola");
                      });
                    }

                    /* virusList.add("Ebola"); */
                  }, // Handle your callback

                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color0,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Ebola",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color1 == notChoosedColor) {
                      setState(() {
                        _color1 = choosedColor;
                        numberOfItem++;
                        virusList.add("Coils");
                      });
                    } else {
                      setState(() {
                        _color1 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Coils");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color1,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Coils",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color2 == notChoosedColor) {
                      setState(() {
                        _color2 = choosedColor;
                        numberOfItem++;
                        virusList.add("Bacterial");
                      });
                    } else {
                      setState(() {
                        _color2 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Bacterial");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color2,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Bacterial",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color3 == notChoosedColor) {
                      setState(() {
                        _color3 = choosedColor;
                        numberOfItem++;
                        virusList.add("Hantavirus");
                      });
                    } else {
                      setState(() {
                        _color3 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Hantavirus");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color3,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Hantavirus",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color4 == notChoosedColor) {
                      setState(() {
                        _color4 = choosedColor;
                        numberOfItem++;
                        virusList.add("Bird flu virus");
                      });
                    } else {
                      setState(() {
                        _color4 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Bird flu virus");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color4,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Bird flu virus",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color5 == notChoosedColor) {
                      setState(() {
                        _color5 = choosedColor;
                        numberOfItem++;
                        virusList.add("Lassa virus");
                      });
                    } else {
                      setState(() {
                        _color5 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Lassa virus");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color5,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Lassa virus",
                          textAlign: TextAlign.center,
                        ),
                      )),
                )),
            Divider(color: Colors.black),
            Padding(
                padding: EdgeInsets.only(top: height / 300),
                child: InkWell(
                  onTap: () {
                    if (_color6 == notChoosedColor) {
                      setState(() {
                        _color6 = choosedColor;
                        numberOfItem++;
                        virusList.add("Junin virus");
                      });
                    } else {
                      setState(() {
                        _color6 = notChoosedColor;
                        numberOfItem--;
                        virusList.remove("Junin virus");
                      });
                    }
                  }, // Handle your callback
                  child: Ink(
                      height: height / 20,
                      width: width,
                      color: _color6,
                      child: Padding(
                        //左边添加8像素补白
                        padding: EdgeInsets.only(top: height / 100),
                        child: new Text(
                          "Junin virus",
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
                        child: displayButton(),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
