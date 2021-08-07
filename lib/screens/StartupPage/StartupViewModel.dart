import 'package:dump/screens/Constant/const.dart';
import 'package:dump/screens/ResidentHomeView/ResidentHomeView.dart';
import 'package:dump/services/notificationService.dart';
import 'package:stacked/stacked.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';

class StartUpViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final NotificationService _notificationService =
      locator<NotificationService>();
  StartUpViewModel() {
    _notificationService.initialiseLocalnotifiction();
    checkUserLoggedIn();
  }
  // intialrun(){

  // }

  //checks if user is already logged in or not.
  checkUserLoggedIn() async {
    setBusy(true);
    var isLoggedin = await _authService.isLoggedIn();
    if (isLoggedin == true) {
      setBusy(false);
      if (_authService.currentUser.type == Resident) {
        _notificationService.updateToken();
        Future.delayed(Duration.zero, () {
          _navigationService.navigateTo(ResidentHomeViewRoute);
        });
      } else if (_authService.currentUser.type == Driver) {
        Future.delayed(Duration.zero, () {
          _navigationService.navigateTo(DriverHomeViewRoute);
        });
      }
    } else {
      setBusy(false);
    }
  }

  navigateToResidentLoginPage() async {
    await _navigationService.navigateTo(ResidentLoginViewRoute);
  }

  navigateToDriverLoginPage() async {
    await _navigationService.navigateTo(DriverLoginRoute);
  }
}
