import 'package:dump/Model/UserData.dart';
import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:stacked/stacked.dart';

class SettingPageViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();

  UserData get currentUser => _authService.currentUser;

  navigateToAboutUs() async {
    await _navigationService.navigateTo(AboutusViewRoute);
  }

  navigateToNotification() async {
    await _navigationService.navigateTo(NotificationRoute);
  }

  logout() async {
    _authService.logout();
    _navigationService.popUntil();
    _navigationService.navigateTo(StartUpRoute);
  }
}
