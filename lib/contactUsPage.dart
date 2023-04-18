import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: height / 40, vertical: width / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('About Us',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
            buildDivider(),
            Center(
              child: CircleAvatar(
                radius: 50,
              ),
            ),
            SizedBox(height: height / 40),
            Center(
              child: Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            buildDivider(),
            SizedBox(height: height / 30),
            Text(
              'Small Team Of Researchers And Developers From FantaHealth.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: height / 30),
            Center(
              child: Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            buildDivider(),
            SizedBox(height: height / 50),
            Text(
              'We Dedicated To Provide A Cheap And Portable Disinfection Method To General Public.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: height / 30),
            Center(
              child: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            buildDivider(),
            SizedBox(height: height / 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  'mgwfantasapp@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Expanded buildDivider() {
  return const Expanded(
    child: Divider(
      color: Colors.black,
      height: 1.5,
    ),
  );
}
