import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget drawer() {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  return Drawer(
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: <Widget>[
          textInput("Request Portal", () {
            _navigationService.navigateTo(DriverRequestPortal);
          }),
          Divider(),
          textInput("Logout", () {
            _authService.logout();
            _navigationService.popUntil();
            _navigationService.navigateTo(StartUpRoute);
          })
        ],
      ),
    ),
  );
}

Widget textInput(value, Function() onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        )),
  );
}
