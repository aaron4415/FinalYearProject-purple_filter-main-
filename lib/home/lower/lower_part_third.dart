import 'package:flutter/material.dart';
import 'package:purple_filter/home/lower/lower_part_first.dart';
import 'package:purple_filter/home/upper/upper_part.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'display_table.dart';

class LowerPartThird extends StatefulWidget {
  const LowerPartThird({Key? key}) : super(key: key);

  @override
  State<LowerPartThird> createState() => _LowerPartThirdState();
}

class _LowerPartThirdState extends State<LowerPartThird> {
  IconData barChartSharp = const IconData(0xe7ca, fontFamily: 'MaterialIcons');
  List<String> virusList = ["Ebola", "Bacterial", "H1N1"];

  _loadVirusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      virusList = prefs.getStringList("virusList") ??
          ["Ebola", "Bacterial", "H1N1"];
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

    Widget displayTableBox = Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width / 3 * 2),
                child: displayTable(width, virusList)));

    return Center(
        child: Container(
          width: width * 0.7,
          margin: const EdgeInsets.only(top: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Color.fromARGB(255, 135, 206, 250)),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              shape: BoxShape.rectangle,
              color: const Color.fromARGB(255, 3, 1, 36),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0.0,
                  blurRadius: 10.0
                ),
                if (disinfectionPercentage >= 100)
                BoxShadow(
                  color: finishColor,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0.0,
                  blurRadius: 13.0
                )
              ]
          ),
          child: Center(child: displayTableBox)
        )
    );
  }
}
