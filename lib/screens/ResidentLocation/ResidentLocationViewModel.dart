import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/Model/UserData.dart';
import 'package:dump/Model/driverData.dart';
import 'package:dump/locator.dart';
import 'package:dump/screens/ResidentHomeView/ResidentHomeView.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:latlng/latlng.dart';

class ResidentLocationViewModel extends BaseViewModel {
  final LocationService _locationService = locator<LocationService>();
  final AuthService _authService = locator<AuthService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  LocationData get locationData => _locationService.locationData;
  LatLng myLocation = LatLng(0, 0);
  Stream<QuerySnapshot> allDriversData;
  // List<LatLng> driverLocation = [LatLng(12.0061663, 74.533465)];

  UserData get currentUser => _authService.currentUser;
  ResidentLocationViewModel() {
    if (currentUser?.lat != 0 && currentUser?.lon != 0)
      myLocation = LatLng(currentUser.lat, currentUser.lon);
    _locationService.hasServiceEnabled();
    _locationService.hasPermission();
    if (_firebaseService.listener == 0)
      _firebaseService.driverLiveData.listen(_onLiveLocation);
    _firebaseService.listener = 1;
  }

  // runOnce() {
  //   if (currentUser?.lat != 0 && currentUser?.lon != 0)
  //     myLocation = LatLng(currentUser!.lat!, currentUser!.lon!);
  //   notifyListeners();
  //   _locationService.hasServiceEnabled();
  //   _locationService.hasPermission();
  // _firebaseService.driverLiveData.listen(_onLiveLocation);
  // }

  getCurrentLocationAndUpdate(context) async {
    _locationService.hasServiceEnabled();
    _locationService.hasPermission();
    _locationService.getCurrentLocation();
    myLocation = LatLng(_locationService.locationData.latitude,
        _locationService.locationData.longitude);
    var status = await _firebaseService.updateLocationResidentalUser(
        _locationService.locationData.longitude,
        _locationService.locationData.latitude,
        currentUser.userId);
    if (status) {
      await _authService.populateCurrentUser(currentUser.userId);
      notifyListeners();
      var snackBar = SnackBar(content: Text("Adding your current location"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = SnackBar(
        content: Text("There was some problem, plz check your internet."),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onLiveLocation(DriverData data) {
    markers.clear();

    print("sss : ${data.lat} and ${data.lon} and ${data.name} ");
    if ((data.lat != 0.01 || data.lat != null) &&
        (data.lon != 0.01 || data.lon != null)) {
      // print("sss : ${data.lat} and ${data.lon} and ${data.name} ");
      markers.add(LatLng(data.lat, data.lon));
      print(" ONLINE markers " + markers.length.toString());
      notifyListeners();
    }
  }
}
