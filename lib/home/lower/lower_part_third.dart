import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../upper/upper_part.dart';
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
              border: Border.all(width: 5.0, color: Color.fromARGB(245, 245, 245, 255)),
              shape: BoxShape.rectangle),
          child: Center(child: displayTableBox)
        )
    );
  }
}
