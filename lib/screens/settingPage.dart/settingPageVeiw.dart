import 'package:dump/Model/UserData.dart';
import 'package:dump/locator.dart';
import 'package:dump/screens/settingPage.dart/settingPageViewModel.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/locationService.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/widget/menuButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class Settings extends StatelessWidget {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final LocationService _locationService = locator<LocationService>();
  final AuthService _authService = locator<AuthService>();

  UserData get currentUser => _authService.currentUser;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingPageViewModel>.reactive(
        builder: (context, model, _) => SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //user info
                      SizedBox(
                        height: 140,
                        child: RaisedButton(
                            onPressed: () {
                              print("button clicked");
                            },
                            color: Color.fromRGBO(48, 72, 75, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 20,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                ),
                                Positioned(
                                  top: 45,
                                  left: 110,
                                  child: Text(
                                    model.currentUser.name.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ),
                                Positioned(
                                  top: 75,
                                  left: 110,
                                  child: Text(
                                    model.currentUser.phoneNumber.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      //set location field
                      menuButton(() async {
                        _locationService.getCurrentLocation();

                        bool result =
                            await _firebaseService.updateLocationResidentalUser(
                                _locationService.locationData.latitude,
                                _locationService.locationData.longitude,
                                currentUser.userId);
                        if (result) {
                          await _firebaseService.getUser(currentUser.userId);
                          final snackBar = SnackBar(
                              content: Text("Location updated successfully."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar =
                              SnackBar(content: Text("Something went wrong."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }, 'Set Location', Icons.add_location_alt_outlined),
                      SizedBox(
                        height: 20,
                      ),

                      //notifications field
                      menuButton(() {
                        model.navigateToNotification();
                      }, "Notifications", Icons.notifications_active_outlined),

                      SizedBox(
                        height: 20,
                      ),

                      //invite friends field

                      menuButton(() {
                        Share.share('Invite Friends Via..');
                      }, 'Invite Friends', Icons.share),

                      SizedBox(
                        height: 20,
                      ),

                      //about us field
                      menuButton(() {
                        model.navigateToAboutUs();
                      }, "About us", Icons.info_outline),

                      SizedBox(
                        height: 20,
                      ),

                      //logout field
                      menuButton(() {
                        model.logout();
                      }, "Logout", Icons.logout),

                      SizedBox(
                        height: 30,
                      ),

                      //version text
                      Container(
                        child: Text(
                          'Version: 1.0.0.5',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ),
            ),
        viewModelBuilder: () => SettingPageViewModel());
  }
}
