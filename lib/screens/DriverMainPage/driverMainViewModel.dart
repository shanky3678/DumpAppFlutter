import 'package:dump/Model/UserData.dart';
import 'package:dump/screens/Constant/const.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/dialogService.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import '../../locator.dart';

class DriverMainPageModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  DriverMainPageModel() {
    checkLocationServiceEnabled();
    checkLocationPermissionEnabled();
    trackLocation();
    fetchResidentDetails();
    liveLocationTracking();
  }

  UserData get currentUser => _authService.currentUser;
  var location = Location();
  var _displayLoaction;
  get displayLoaction => _displayLoaction;
  List<UserData> userData = [];
  List<LatLng> allMarkers = [];
  LatLng liveLocation = LatLng(0.0, 0.0);

  checkLocationServiceEnabled() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      var serviceEnabled = await location.requestService();
      print("service enabled $serviceEnabled");
      if (!serviceEnabled) {
        //TODO: show popup and close the app
        _dialogService.dialog("Required Permission",
            "Without serviceEnabled permission app is not likly to run! ",
            onPressed: () {
          _navigationService.goBack();
          checkLocationPermissionEnabled();
          checkLocationServiceEnabled();
          trackLocation();
        });
      }
    }
  }

  trackLocation() {
    location.onLocationChanged.listen((locationData) {
      _displayLoaction = locationData;
      print("constant keep tracking $_displayLoaction");
      notifyListeners();
    });
  }

  checkLocationPermissionEnabled() async {
    var _permissionEnabled = await location.hasPermission();
    if (_permissionEnabled == PermissionStatus.denied) {
      var requestPermission = await location.requestPermission();
      if (requestPermission == PermissionStatus.denied) {
        _dialogService.dialog("Required Permission",
            "Without this permission app is not likly to run! ", onPressed: () {
          _navigationService.goBack();
          checkLocationPermissionEnabled();
          checkLocationServiceEnabled();
          trackLocation();
        });
      } else {
        return;
      }
    }
  }

  fetchResidentDetails() async {
    setBusy(true);
    userData.clear();
    userData = await _firebaseService.getResidentDetails();
    userData.forEach((element) {
      allMarkers.add(LatLng(element.lat, element.lon));
    });
    setBusy(false);
  }

  liveLocationTracking() {
    location.onLocationChanged.listen((event) {
      liveLocation = LatLng(event.latitude, event.longitude);
      _firebaseService.liveLocationUpdate(
          userId: currentUser.userId,
          type: Driver,
          lon: event.longitude,
          lat: event.latitude);
    });
  }
}
