import 'package:dump/services/navigationService.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

class DialogService {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<dynamic> dialog(String title, String message, {onPressed}) async {
    await showDialog(
        context: _navigationService.navigatorKey.currentContext,
        builder: (context) => SimpleDialog(
              title: Text(title),
              children: [
                SimpleDialogOption(
                  child: Text(message),
                ),
                SimpleDialogOption(
                  onPressed: onPressed == null
                      ? () {
                          _navigationService.goBack();
                        }
                      : onPressed,
                  child: Text("Okay"),
                )
              ],
            ));
  }
}
