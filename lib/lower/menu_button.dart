import 'package:flutter/material.dart';
import 'package:purple_filter/lower/red_button.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {

  @override
  Widget build(BuildContext context) {
    dynamic width = MediaQuery.of(context).size.width;
    dynamic height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: const RoundedRectangleBorder(),
          fixedSize: Size(width / 3, height / 16)
      ),
      child: const Text('Menu')
    );
    //return Text(distance.toStringAsFixed(3));
  }
}
