import 'package:dump/screens/DriverMainPage/driverMainView.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/dialogService.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/locationService.dart';
import 'package:dump/services/navigationService.dart';
import 'package:dump/services/notificationService.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => NotificationService());
}
