import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
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

class ConfigStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.txt');
  }

  Future<String> readConfig() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "english";
    }
  }

  Future<File> writeConfig(String contents) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(contents);
  }
}

class selectLanguagePage extends StatefulWidget {
  const selectLanguagePage({super.key, required this.storage});

  final ConfigStorage storage;

  @override
  State<selectLanguagePage> createState() => _selectLanguagePageState();
}

class _selectLanguagePageState extends State<selectLanguagePage> {
  String _config = "english";
  bool _firstTimeToUse = true;
  @override
  void initState() {
    super.initState();
    _loadFirstTimeToUse();
    widget.storage.readConfig().then((value) {
      setState(() {
        _config = value;
      });
    });
  }

  _loadFirstTimeToUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstTimeToUse = prefs.getBool("firstTime") ?? true;
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

  String showSelect() {
    switch (_config) {
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

  Future<File> _changeLanguage(String newLanguage) {
    setState(() {
      _config = newLanguage;
    });
    print(_config);
    // Write the variable as a string to the file.
    return widget.storage.writeConfig(_config);
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
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text('select Language Page'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  showSelect(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                ElevatedButton(
                  child: Text("ENGLISH"),
                  onPressed: () {
                    changedMessage("ENGLISH");
                    _changeLanguage("english");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text("简体中文"),
                  onPressed: () {
                    changedMessage("简体中文");
                    _changeLanguage("simplifiedChinese");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text("繁體中文"),
                  onPressed: () {
                    changedMessage("繁體中文");
                    _changeLanguage("traditionalChinese");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text("日本語"),
                  onPressed: () {
                    changedMessage("日本語");
                    _changeLanguage("japanese");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text(""),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text(""),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
                ElevatedButton(
                  child: Text(""),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white, // foreground
                  ),
                ),
              ]),
        ));
  }
}
