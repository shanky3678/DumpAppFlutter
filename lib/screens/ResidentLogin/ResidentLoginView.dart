import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/screens/Constant/const.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/widget/LoadingState.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResidentLoginView extends StatefulWidget {
  @override
  _ResidentLoginViewState createState() => _ResidentLoginViewState();
}

class _ResidentLoginViewState extends State<ResidentLoginView> {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  bool isOTP = false; // flag to make the otp field visible
  bool enabled = false; // flag to disable the mobile number input widget
  bool isBusy = false;

  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otpController = TextEditingController();
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
                        image: AssetImage("assets/images/user_login.png"),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  // mobile number input field
                  Visibility(
                    visible: !isOTP,
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        child: TextField(
                          controller: _phoneNumber,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text(
                                "+91",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),

                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(45.0),
                              ),
                            ),
                            // hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Mobile number",
                          ),
                        )),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: !isOTP,
                    child: Align(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () {
                            if (_phoneNumber.text.isNotEmpty) {
                              setState(() {
                                isBusy = true;
                              });
                              _authService
                                  .phoneVerification("+91" + _phoneNumber.text);
                              isOTP = true;
                              enabled = true;
                              setState(() {
                                isBusy = false;
                              });
                            }
                          },
                          child: Text("Login"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                          color: Color.fromRGBO(242, 161, 84, 1),
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    //OTP input widget
                    visible: isOTP,
                    child: Container(
                        margin: const EdgeInsets.only(right: 20, left: 20),
                        child: TextField(
                          controller: _otpController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.visibility_off),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(45.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter OTP",
                              fillColor: Colors.white),
                        )),
                  ),
                  Visibility(
                    visible: isOTP,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      child: Align(
                        widthFactor: 5,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            _authService
                                .phoneVerification("+91" + _phoneNumber.text);
                            isOTP = true;
                            enabled = true;
                          },
                          child: Text("Send again"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isOTP,
                    child: Align(
                        //submit-OTP button
                        alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              isBusy = true;
                            });
                            if (_otpController.text.isNotEmpty) {
                              await _authService.signInWithcredential(
                                  _otpController.text,
                                  Resident,
                                  "+91" + _phoneNumber.text);
                            }
                            setState(() {
                              isBusy = false;
                            });
                          },
                          child: Text("Submit OTP"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                          color: Color.fromRGBO(242, 161, 84, 1),
                        )),
                  ),
                ],
              ));
  }
}
