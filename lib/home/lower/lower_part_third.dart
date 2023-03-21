import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'display_table.dart';

class LowerPartThird extends StatefulWidget {
  const LowerPartThird({Key? key}) : super(key: key);

  @override
  State<LowerPartThird> createState() => _LowerPartThirdState();
}

class _LowerPartThirdState extends State<LowerPartThird> {
  IconData barChartSharp = const IconData(0xe7ca, fontFamily: 'MaterialIcons');
  List<String> virusList = [];
  _loadVirusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      virusList = prefs.getStringList("virusList") ??
          ["Covid-19", "Coils", "Bacterial"];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVirusList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget tableTitleText = const Text('Prediction disinfection level',
        style: TextStyle(color: Colors.blue));

    Widget tableTitleIcon = Icon(barChartSharp, color: Colors.blue);

    Widget tableTitle = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [tableTitleText, tableTitleIcon]));

    Widget displayTableBox = Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width / 3 * 2),
                child: displayTable(width, virusList))));

    return Center(
        child: Container(
            margin: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.rectangle),
            child: Column(children: [tableTitle, displayTableBox])));
  }
}
