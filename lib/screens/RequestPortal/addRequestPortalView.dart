import 'package:dump/services/firebaseServices.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

// ignore: must_be_immutable
class RequestForm extends StatelessWidget {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _address = TextEditingController();
  void validate(BuildContext context) async {
    if (formkey.currentState.validate()) {
      var result = await _firebaseService.addPickUpRequest(
          _date.text, _time.text, _address.text);
      //validation
      if (result) {
        _date.clear();
        _time.clear();
        _address.clear();
        final snackBar = SnackBar(content: Text("Submitted Successfully."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print("Error");
      final snackBar = SnackBar(content: Text("Something went wrong."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request A Pickup"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          //body which includes three TextFormField
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Form(
              autovalidate: true,
              key: formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _date,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        hintText: "DD/MM/YYYY",
                        labelText: "Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0))),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _time,
                      decoration: InputDecoration(
                          hintText: "HH/mm AM or PM",
                          labelText: "Time",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _address,
                      maxLines: 10,
                      decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0))),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0), //button code
                      child: RaisedButton(
                        onPressed: () => validate(context),
                        child: Text("SUBMIT"),
                        color: Color.fromRGBO(242, 161, 84, 1),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0)),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
