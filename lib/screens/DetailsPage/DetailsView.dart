import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/screens/Constant/const.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsView extends StatefulWidget {
  final String phoneNumber;
  final String type;
  final String userId;

  DetailsView({this.phoneNumber = '', this.type = '', this.userId = ''});

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  double longitude = 0.01;
  double latitude = 0.01;
  bool isBusy = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: isBusy
            ? loadingState()
            : ListView(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage(
                          "assets/images/details.png",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  // mobile number input field
                  Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _name,
                        keyboardType: TextInputType.name,
                        decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(45.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Name",
                            fillColor: Colors.white),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    visible: widget.type == Driver ? false : true,
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _address,
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                              suffix: IconButton(
                                icon: Icon(Icons.location_city),
                                onPressed: () {},
                              ),
                              prefixIcon: Icon(Icons.person),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(45.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Address",
                              fillColor: Colors.white),
                        )),
                  ),

                  Align(
                      //submit-OTP button
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () async {
                          if (_name.text.isNotEmpty &&
                              widget.phoneNumber.isNotEmpty &&
                              widget.type.isNotEmpty) {
                            setState(() {
                              isBusy = true;
                            });
                            var token =
                                await FirebaseMessaging.instance.getToken();
                            var result = await _firebaseService.addDetails(
                                _name.text,
                                widget.phoneNumber,
                                widget.type,
                                widget.userId,
                                _address.text,
                                latitude,
                                longitude,
                                token);
                            if (result) {
                              await _authService
                                  .populateCurrentUser(widget.userId);
                              if (widget.type == Driver) {
                                _navigationService.popUntil();
                                await _navigationService
                                    .navigateTo(DriverHomeViewRoute);
                              } else if (widget.type == Resident) {
                                _navigationService.popUntil();
                                await _navigationService
                                    .navigateTo(ResidentHomeViewRoute);
                              }
                            }
                            setState(() {
                              isBusy = false;
                            });
                          } else {
                            var snackBar = SnackBar(
                                content: Text("Please fill all the blanks"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Text("Done"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        color: Color.fromRGBO(242, 161, 84, 1),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ));
  }

  Widget dropDown({model, context}) {
    return Container(
        height: 60.0,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20, left: 20, top: 20.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(23.0)),
        width: double.infinity,
        child: DropdownButton<String>(
          isExpanded: true,
          onChanged: (value) => {
            model.changeValue(value),
          },
          value: model.dropDownValue,
          underline: SizedBox(),
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.purple,
          ),
          iconSize: 28,
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0),
          items: <String>[
            'Resident',
            'Driver',
          ]
              .map<DropdownMenuItem<String>>(
                  (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
              .toList(),
        ));
  }
}
