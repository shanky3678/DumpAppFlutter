import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/Model/UserData.dart';
import 'package:dump/Model/driverData.dart';
import 'package:dump/locator.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/locationService.dart';
import 'package:dump/services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:latlng/latlng.dart';
import 'dart:math';

class ResidentLocationViewModel extends BaseViewModel {
  final LocationService _locationService = locator<LocationService>();
  final AuthService _authService = locator<AuthService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  LocationData get locationData => _locationService.locationData;
  LatLng myLocation = LatLng(0, 0);
  Stream<QuerySnapshot> allDriversData;
  List<LatLng> driverLocation = [LatLng(0, 0)];

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
    var status = await _firebaseService.updateData(
        userId: currentUser.userId,
        type: currentUser.type,
        lon: _locationService.locationData.longitude,
        lat: _locationService.locationData.latitude);
    if (status) {
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
    driverLocation.clear();
    print("sss : ${data.lat} and ${data.lon} and ${data.name} ");

    print("sss2 : ${data.lat} and ${data.lon} and ${data.name} ");
    driverLocation.add(LatLng(data.lat, data.lon));
    notifyListeners();
  }
}
