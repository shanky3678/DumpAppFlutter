import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget menuButton(Function() onPressed, String title, IconData icon) {
  return SizedBox(
    width: 354,
    height: 55,
    child: RaisedButton(
        onPressed: onPressed,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 9,
              child: Icon(
                icon,
                color: Colors.black,
                size: 36,
              ),
            ),
            Positioned(
              left: 60,
              top: 17,
              child: Text(
                title,
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        )),
  );
}
