import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  var argument;
  Testing({Key key, this.argument = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(argument),
      ),
    );
  }
}
