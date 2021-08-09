import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/screens/ComplaintPortal/ComplaintPortalView.dart';
import 'package:dump/screens/RequestPortal/RequestPortalView.dart';
import 'package:dump/services/navigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utilities extends StatelessWidget {
  NavigationService _navigationService = locator<NavigationService>();
  String a = 'Color.fromRGBO(48, 72, 75, 1)';
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //on request arrival field
        SizedBox(
          width: 354,
          height: 73,
          child: RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestLanding()));
                print("button clicked");
              },
              color: Color.fromRGBO(48, 72, 75, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Icon(
                      Icons.more_time_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    left: 90,
                    top: 25,
                    child: Text(
                      'On Request Arrival',
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),

        SizedBox(
          height: 10,
        ),

        //complaint portal
        SizedBox(
          width: 354,
          height: 73,
          child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComplaintLanding()));
                print("button clicked");
              },
              color: Color.fromRGBO(48, 72, 75, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Icon(
                      Icons.assignment_turned_in,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    left: 90,
                    top: 25,
                    child: Text(
                      'Complaint Portal',
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),

        SizedBox(
          height: 10,
        ),

        //calendar field
        SizedBox(
          width: 354,
          height: 73,
          child: RaisedButton(
              onPressed: () async {
                await _navigationService.navigateTo(CalenderViewRoute);
              },
              color: Color.fromRGBO(48, 72, 75, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    left: 90,
                    top: 25,
                    child: Text(
                      'Calendar',
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),

        SizedBox(
          height: 10,
        ),

        //Recycle field
        SizedBox(
          width: 354,
          height: 73,
          child: RaisedButton(
              onPressed: () async {
                await _navigationService.navigateTo(RecyleViewPage);
              },
              color: Color.fromRGBO(48, 72, 75, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Icon(
                      Icons.workspaces_filled,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    left: 90,
                    top: 25,
                    child: Text(
                      'Recycle',
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),

        SizedBox(
          height: 10,
        ),
      ],
    ));
  }
}
