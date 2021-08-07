import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dump/screens/settingPage.dart/settingPageVeiw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dump/screens/ResidentLocation/ResidentLocationView.dart';
import 'package:dump/screens/Utilities/Utilities.dart';

class ResidentHomeView extends StatefulWidget {
  _ResidentHomeViewState createState() => _ResidentHomeViewState();
}

class _ResidentHomeViewState extends State<ResidentHomeView> {
  var _page = 0;
  final pages = [ResidentLocation(), Utilities(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          buttonBackgroundColor: Color.fromRGBO(48, 72, 75, 1),
          color: Color.fromRGBO(48, 72, 75, 1),
          backgroundColor: Colors.white,
          items: [
            Icon(
              Icons.add_location,
              color: Colors.white,
              size: 40,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
            Icon(Icons.settings, color: Colors.white, size: 40),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          }),
      body: pages[_page],
    );
  }
}
